require "faraday"
require "json"

module WebScrapingAI
  class Client
    PROXY_TYPES = %w[datacenter residential stealth].freeze
    COUNTRIES = %w[us gb de it fr ca es ru jp kr in hk tr].freeze
    DEVICES = %w[desktop mobile tablet].freeze
    TEXT_FORMATS = %w[plain xml json].freeze
    FORMATS = %w[json text].freeze
    SERP_ENGINES = %w[google].freeze

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

    # GET /serp — returns parsed search engine results for `q` as a Hash
    # (search_parameters, search_information, organic_results, related_searches, pagination).
    # Query-shaped: none of the page-fetch options apply. Flat 15 credits per search.
    # `q` must be a non-blank String (sent as-is, untrimmed). `page`, when given, must be an
    # Integer >= 1; the server rejects values above 100 with a 400 (not billed).
    def serp(q:, engine: nil, gl: nil, hl: nil, page: nil)
      raise ArgumentError, "q is required" if q.nil? || (q.is_a?(String) && q.strip.empty?)
      raise ArgumentError, "q must be a String" unless q.is_a?(String)
      raise ArgumentError, "page must be an Integer >= 1" unless page.nil? || (page.is_a?(Integer) && page >= 1)

      get("/serp", q: q, engine: engine, gl: gl, hl: hl, page: page)
    end

    # GET /data — returns structured JSON for a page on a supported site as a Hash
    # (request_parameters: url/provider/type, parse_status, data). Flat 15 credits per request.
    #
    # The client never checks which site `url` belongs to: supported sites (e.g. YouTube, TikTok,
    # X/Twitter, LinkedIn, Instagram, Reddit) are added server-side. An unsupported URL or page type
    # returns a 400 that is not charged (BadRequestError); its message lists what is supported.
    # `provider`, `type` and `parse_status` are open sets of strings; `data` may be nil.
    #
    # `country`: two-letter country code of the proxy used to fetch the page, `us` by default.
    # `transcript`: YouTube videos only. Also fetch the video's transcript into `data.transcript`.
    # It's null when no matching captions are available. If the transcript fetch itself fails, the
    # whole request fails with a 500 and is not charged.
    # `transcript_language`: caption language to pick, e.g. `en` or `de`. Without it, English is
    # preferred, then the first available track. If the video has no captions in that language,
    # `data.transcript` is null.
    #
    # Any other keyword arguments are sent as-is as extra query params (for provider-specific params
    # added later). Values must be String, Integer, Float or boolean (nil omits the param); the names
    # `api_key`, `url`, `country`, `transcript` and `transcript_language` raise ArgumentError.
    # None of the page-fetch options apply.
    def data(url, country: nil, transcript: nil, transcript_language: nil, **params)
      raise ArgumentError, "url is required" if url.nil? || (url.is_a?(String) && url.strip.empty?)
      raise ArgumentError, "url must be a String" unless url.is_a?(String)

      named = { country: country, transcript: transcript, transcript_language: transcript_language }.compact
      get("/data", url: url, **data_extra_params(params), **named)
    end

    def inspect
      "#<#{self.class.name} base_url=#{configuration.base_url.inspect} api_key=\"[FILTERED]\">"
    end

    # GET /account — returns Hash with remaining_api_calls, resets_at, remaining_concurrency, email.
    def account
      get("/account")
    end

    private

    DATA_RESERVED_PARAMS = %w[api_key url].freeze
    DATA_TYPED_PARAMS = %w[country transcript transcript_language].freeze
    private_constant :DATA_RESERVED_PARAMS, :DATA_TYPED_PARAMS

    # Extra /data query params are passed through untouched (same encoder, so `&`/`=` are escaped),
    # except that they can't override the credentials or the target URL, and can't repeat a typed
    # param (a string key like "country" would otherwise collide with `country:`).
    def data_extra_params(params)
      params.each_with_object({}) do |(key, value), extra|
        name = key.to_s
        raise ArgumentError, "#{name} can't be passed as an extra /data param" if DATA_RESERVED_PARAMS.include?(name)
        if DATA_TYPED_PARAMS.include?(name)
          raise ArgumentError, "#{name} can't be passed as an extra /data param; use the #{name}: option"
        end

        extra[name.to_sym] = data_extra_value(name, value)
      end
    end

    def data_extra_value(name, value)
      case value
      when nil, String, Integer, true, false then value
      when Float
        raise ArgumentError, "extra /data param #{name} must be a finite number" unless value.finite?

        plain_float(value)
      else
        raise ArgumentError, "extra /data param #{name} must be a String, Integer, Float or boolean"
      end
    end

    # Float#to_s switches to exponent notation (1.0e+20, 1.5e-07); send plain decimals instead.
    def plain_float(value)
      text = value.to_s
      return text unless text.include?("e")

      mantissa, exponent = text.split("e")
      fraction_digits = mantissa.split(".")[1].to_s.sub(/0+\z/, "").length
      format("%.#{[fraction_digits - exponent.to_i, 0].max}f", value)
    end

    def redact(text)
      key = configuration.api_key.to_s
      text = text.to_s
      text = text.gsub(key, "[FILTERED]") unless key.empty?
      text.gsub(/api_key=[^&\s"']*/, "api_key=[FILTERED]")
    end

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

    # Transport errors are re-raised with `cause: nil` and a redacted message: the Faraday error (and
    # anything it wraps) may carry the request URL, which contains the API key.
    def get(path, **params)
      response = connection.get(path) do |req|
        req.params = params.merge(api_key: configuration.api_key)
      end
      handle_response(response)
    rescue Faraday::TimeoutError => e
      raise TimeoutError.new(redact(e.message)), cause: nil
    rescue Faraday::ConnectionFailed => e
      raise ConnectionError.new(redact(e.message)), cause: nil
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
