require "faraday"
require "json"

module WebScrapingAI
  class Client
    PROXY_TYPES = %w[datacenter residential stealth].freeze
    COUNTRIES = %w[us gb de it fr ca es ru jp kr in hk tr].freeze
    DEVICES = %w[desktop mobile tablet].freeze
    TEXT_FORMATS = %w[plain xml json].freeze
    FORMATS = %w[json text].freeze

    PAGE_FETCH_OPTIONS = %i[
      headers timeout js js_timeout wait_for proxy country
      custom_proxy device error_on_404 error_on_redirect js_script
    ].freeze

    attr_reader :configuration

    def initialize(api_key: nil, base_url: nil, timeout: nil, open_timeout: nil, adapter: nil, user_agent: nil)
      global = WebScrapingAI.configuration
      @configuration = Configuration.new.tap do |c|
        c.api_key = api_key || global.api_key
        c.base_url = base_url || global.base_url
        c.timeout = timeout || global.timeout
        c.open_timeout = open_timeout || global.open_timeout
        c.adapter = adapter || global.adapter
        c.user_agent = user_agent || global.user_agent
      end

      return unless @configuration.api_key.nil? || @configuration.api_key.to_s.empty?

      raise ConfigurationError,
            "api_key is required (pass api_key: or set WebScrapingAI.configure { |c| c.api_key = ... })"
    end

    # GET /ai/question — returns the LLM's answer about the page.
    # Returns a String by default, or a Hash when format: "json".
    def question(url, question:, **opts)
      get("/ai/question", url: url, question: question, **opts.slice(*PAGE_FETCH_OPTIONS, :format))
    end

    # GET /ai/fields — extracts the named fields from the page.
    # `fields` is a Hash of { field_name => description }. Returns a Hash.
    def fields(url, fields:, **opts)
      get("/ai/fields", url: url, fields: fields, **opts.slice(*PAGE_FETCH_OPTIONS))
    end

    # GET /html — returns the full page HTML as a String.
    def html(url, **opts)
      get("/html", url: url, **opts.slice(*PAGE_FETCH_OPTIONS, :return_script_result, :format))
    end

    # GET /text — returns the visible text content of the page.
    # Returns a String when text_format is "plain"/"xml" (default), or a Hash when text_format: "json".
    def text(url, **opts)
      get("/text", url: url, **opts.slice(*PAGE_FETCH_OPTIONS, :text_format, :return_links))
    end

    # GET /selected — returns HTML of the element matching `selector` as a String.
    def selected(url, selector: nil, **opts)
      get("/selected", url: url, selector: selector, **opts.slice(*PAGE_FETCH_OPTIONS, :format))
    end

    # GET /selected-multiple — returns an Array of HTML strings, one per selector.
    def selected_multiple(url, selectors:, **opts)
      get("/selected-multiple", url: url, selectors: Array(selectors), **opts.slice(*PAGE_FETCH_OPTIONS))
    end

    # GET /account — returns Hash with remaining_api_calls, resets_at, remaining_concurrency, email.
    def account
      get("/account")
    end

    private

    def connection
      @connection ||= Faraday.new(url: configuration.base_url) do |conn|
        conn.options.timeout = configuration.timeout
        conn.options.open_timeout = configuration.open_timeout
        conn.options.params_encoder = QueryEncoder
        conn.headers["User-Agent"] = configuration.user_agent
        conn.headers["Accept"] = "application/json, text/html, text/xml, text/plain"
        conn.adapter(configuration.adapter || Faraday.default_adapter)
      end
    end

    def get(path, **params)
      response = connection.get(path) do |req|
        req.params = params.merge(api_key: configuration.api_key)
      end
      handle_response(response)
    rescue Faraday::TimeoutError => e
      raise TimeoutError, e.message
    rescue Faraday::ConnectionFailed => e
      raise ConnectionError, e.message
    end

    def handle_response(response)
      return parse_body(response) if response.status.between?(200, 299)

      error_class = STATUS_TO_ERROR.fetch(response.status, ApiError)
      data = safe_parse_json(response.body) || {}
      raise error_class.new(
        message: data["message"] || "HTTP #{response.status}",
        status: response.status,
        status_code: data["status_code"],
        status_message: data["status_message"],
        body: data["body"],
        response_body: response.body
      )
    end

    def parse_body(response)
      content_type = response.headers["content-type"].to_s
      if content_type.include?("application/json")
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def safe_parse_json(body)
      return nil if body.nil? || body.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      nil
    end
  end
end
