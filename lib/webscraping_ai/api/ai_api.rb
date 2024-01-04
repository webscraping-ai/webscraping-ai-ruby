=begin
#WebScraping.AI

#WebScraping.AI scraping API provides GPT-powered tools with Chromium JavaScript rendering, rotating proxies, and built-in HTML parsing.

The version of the OpenAPI document: 3.1.3
Contact: support@webscraping.ai
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 7.2.0

=end

require 'cgi'

module WebScrapingAI
  class AIApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Get an answer to a question about a given web page
    # Returns the answer in plain text. Proxies and Chromium JavaScript rendering are used for page retrieval and processing, then the answer is extracted using an LLM model.
    # @param url [String] URL of the target page.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :question Question or instructions to ask the LLM model about the target page.
    # @option opts [Integer] :context_limit Maximum number of tokens to use as context for the LLM model (4000 by default). (default to 4000)
    # @option opts [Integer] :response_tokens Maximum number of tokens to return in the LLM model response. The total context size (context_limit) includes the question, the target page content and the response, so this parameter reserves tokens for the response (see also on_context_limit). (default to 100)
    # @option opts [String] :on_context_limit What to do if the context_limit parameter is exceeded (truncate by default). The context is exceeded when the target page content is too long. (default to 'error')
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}).
    # @option opts [Integer] :timeout Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). (default to 10000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default). (default to true)
    # @option opts [Integer] :js_timeout Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. (default to 2000)
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. (default to 'datacenter')
    # @option opts [String] :country Country of the proxy to use (US by default). Only available on Startup and Custom plans. (default to 'us')
    # @option opts [String] :device Type of device emulation. (default to 'desktop')
    # @option opts [Boolean] :error_on_404 Return error on 404 HTTP status on the target page (false by default). (default to false)
    # @option opts [Boolean] :error_on_redirect Return error on redirect on the target page (false by default). (default to false)
    # @option opts [String] :js_script Custom JavaScript code to execute on the target page.
    # @return [String]
    def get_question(url, opts = {})
      data, _status_code, _headers = get_question_with_http_info(url, opts)
      data
    end

    # Get an answer to a question about a given web page
    # Returns the answer in plain text. Proxies and Chromium JavaScript rendering are used for page retrieval and processing, then the answer is extracted using an LLM model.
    # @param url [String] URL of the target page.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :question Question or instructions to ask the LLM model about the target page.
    # @option opts [Integer] :context_limit Maximum number of tokens to use as context for the LLM model (4000 by default). (default to 4000)
    # @option opts [Integer] :response_tokens Maximum number of tokens to return in the LLM model response. The total context size (context_limit) includes the question, the target page content and the response, so this parameter reserves tokens for the response (see also on_context_limit). (default to 100)
    # @option opts [String] :on_context_limit What to do if the context_limit parameter is exceeded (truncate by default). The context is exceeded when the target page content is too long. (default to 'error')
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}).
    # @option opts [Integer] :timeout Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). (default to 10000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default). (default to true)
    # @option opts [Integer] :js_timeout Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. (default to 2000)
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. (default to 'datacenter')
    # @option opts [String] :country Country of the proxy to use (US by default). Only available on Startup and Custom plans. (default to 'us')
    # @option opts [String] :device Type of device emulation. (default to 'desktop')
    # @option opts [Boolean] :error_on_404 Return error on 404 HTTP status on the target page (false by default). (default to false)
    # @option opts [Boolean] :error_on_redirect Return error on redirect on the target page (false by default). (default to false)
    # @option opts [String] :js_script Custom JavaScript code to execute on the target page.
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def get_question_with_http_info(url, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AIApi.get_question ...'
      end
      # verify the required parameter 'url' is set
      if @api_client.config.client_side_validation && url.nil?
        fail ArgumentError, "Missing the required parameter 'url' when calling AIApi.get_question"
      end
      allowable_values = [4000, 8000, 16000]
      if @api_client.config.client_side_validation && opts[:'context_limit'] && !allowable_values.include?(opts[:'context_limit'])
        fail ArgumentError, "invalid value for \"context_limit\", must be one of #{allowable_values}"
      end
      allowable_values = ["truncate", "error"]
      if @api_client.config.client_side_validation && opts[:'on_context_limit'] && !allowable_values.include?(opts[:'on_context_limit'])
        fail ArgumentError, "invalid value for \"on_context_limit\", must be one of #{allowable_values}"
      end
      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] > 30000
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling AIApi.get_question, must be smaller than or equal to 30000.'
      end

      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling AIApi.get_question, must be greater than or equal to 1.'
      end

      if @api_client.config.client_side_validation && !opts[:'js_timeout'].nil? && opts[:'js_timeout'] > 20000
        fail ArgumentError, 'invalid value for "opts[:"js_timeout"]" when calling AIApi.get_question, must be smaller than or equal to 20000.'
      end

      if @api_client.config.client_side_validation && !opts[:'js_timeout'].nil? && opts[:'js_timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"js_timeout"]" when calling AIApi.get_question, must be greater than or equal to 1.'
      end

      allowable_values = ["datacenter", "residential"]
      if @api_client.config.client_side_validation && opts[:'proxy'] && !allowable_values.include?(opts[:'proxy'])
        fail ArgumentError, "invalid value for \"proxy\", must be one of #{allowable_values}"
      end
      allowable_values = ["us", "gb", "de", "it", "fr", "ca", "es", "ru", "jp", "kr"]
      if @api_client.config.client_side_validation && opts[:'country'] && !allowable_values.include?(opts[:'country'])
        fail ArgumentError, "invalid value for \"country\", must be one of #{allowable_values}"
      end
      allowable_values = ["desktop", "mobile", "tablet"]
      if @api_client.config.client_side_validation && opts[:'device'] && !allowable_values.include?(opts[:'device'])
        fail ArgumentError, "invalid value for \"device\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/ai/question'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'url'] = url
      query_params[:'question'] = opts[:'question'] if !opts[:'question'].nil?
      query_params[:'context_limit'] = opts[:'context_limit'] if !opts[:'context_limit'].nil?
      query_params[:'response_tokens'] = opts[:'response_tokens'] if !opts[:'response_tokens'].nil?
      query_params[:'on_context_limit'] = opts[:'on_context_limit'] if !opts[:'on_context_limit'].nil?
      query_params[:'headers'] = opts[:'headers'] if !opts[:'headers'].nil?
      query_params[:'timeout'] = opts[:'timeout'] if !opts[:'timeout'].nil?
      query_params[:'js'] = opts[:'js'] if !opts[:'js'].nil?
      query_params[:'js_timeout'] = opts[:'js_timeout'] if !opts[:'js_timeout'].nil?
      query_params[:'proxy'] = opts[:'proxy'] if !opts[:'proxy'].nil?
      query_params[:'country'] = opts[:'country'] if !opts[:'country'].nil?
      query_params[:'device'] = opts[:'device'] if !opts[:'device'].nil?
      query_params[:'error_on_404'] = opts[:'error_on_404'] if !opts[:'error_on_404'].nil?
      query_params[:'error_on_redirect'] = opts[:'error_on_redirect'] if !opts[:'error_on_redirect'].nil?
      query_params[:'js_script'] = opts[:'js_script'] if !opts[:'js_script'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/html'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'String'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['api_key']

      new_options = opts.merge(
        :operation => :"AIApi.get_question",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AIApi#get_question\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
