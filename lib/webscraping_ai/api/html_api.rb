=begin
#WebScraping.AI

#A client for https://webscraping.ai API. It provides a web scaping automation API with Chrome JS rendering, rotating proxies and builtin HTML parsing.

The version of the OpenAPI document: 2.0.1
Contact: support@webscraping.ai
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 4.3.1

=end

require 'cgi'

module WebScrapingAI
  class HTMLApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Page HTML by URL
    # Returns just HTML on success, JSON on error
    # @param url [String] URL of the target page
    # @param [Hash] opts the optional parameters
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;})
    # @option opts [Integer] :timeout Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) (default to 5000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default), costs 2 requests (default to true)
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) (default to 'datacenter')
    # @return [nil]
    def get_html(url, opts = {})
      get_html_with_http_info(url, opts)
      nil
    end

    # Page HTML by URL
    # Returns just HTML on success, JSON on error
    # @param url [String] URL of the target page
    # @param [Hash] opts the optional parameters
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;})
    # @option opts [Integer] :timeout Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def get_html_with_http_info(url, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: HTMLApi.get_html ...'
      end
      # verify the required parameter 'url' is set
      if @api_client.config.client_side_validation && url.nil?
        fail ArgumentError, "Missing the required parameter 'url' when calling HTMLApi.get_html"
      end
      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] > 30000
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling HTMLApi.get_html, must be smaller than or equal to 30000.'
      end

      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling HTMLApi.get_html, must be greater than or equal to 1.'
      end

      allowable_values = ["datacenter", "residential"]
      if @api_client.config.client_side_validation && opts[:'proxy'] && !allowable_values.include?(opts[:'proxy'])
        fail ArgumentError, "invalid value for \"proxy\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/html'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'url'] = url
      query_params[:'headers'] = opts[:'headers'] if !opts[:'headers'].nil?
      query_params[:'timeout'] = opts[:'timeout'] if !opts[:'timeout'].nil?
      query_params[:'js'] = opts[:'js'] if !opts[:'js'].nil?
      query_params[:'proxy'] = opts[:'proxy'] if !opts[:'proxy'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/html'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      # return_type
      return_type = opts[:return_type] 

      # auth_names
      auth_names = opts[:auth_names] || ['api_key']

      new_options = opts.merge(
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: HTMLApi#get_html\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Page HTML by URL with POST request to the target page
    # Returns just HTML on success, JSON on error. Request body will be passed to the target page.
    # @param url [String] URL of the target page
    # @param [Hash] opts the optional parameters
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;})
    # @option opts [Integer] :timeout Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) (default to 5000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default), costs 2 requests (default to true)
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) (default to 'datacenter')
    # @option opts [Hash<String, Object>] :request_body Request body to pass to the target page
    # @return [nil]
    def post_html(url, opts = {})
      post_html_with_http_info(url, opts)
      nil
    end

    # Page HTML by URL with POST request to the target page
    # Returns just HTML on success, JSON on error. Request body will be passed to the target page.
    # @param url [String] URL of the target page
    # @param [Hash] opts the optional parameters
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;})
    # @option opts [Integer] :timeout Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
    # @option opts [Hash<String, Object>] :request_body Request body to pass to the target page
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def post_html_with_http_info(url, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: HTMLApi.post_html ...'
      end
      # verify the required parameter 'url' is set
      if @api_client.config.client_side_validation && url.nil?
        fail ArgumentError, "Missing the required parameter 'url' when calling HTMLApi.post_html"
      end
      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] > 30000
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling HTMLApi.post_html, must be smaller than or equal to 30000.'
      end

      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling HTMLApi.post_html, must be greater than or equal to 1.'
      end

      allowable_values = ["datacenter", "residential"]
      if @api_client.config.client_side_validation && opts[:'proxy'] && !allowable_values.include?(opts[:'proxy'])
        fail ArgumentError, "invalid value for \"proxy\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/html'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'url'] = url
      query_params[:'headers'] = opts[:'headers'] if !opts[:'headers'].nil?
      query_params[:'timeout'] = opts[:'timeout'] if !opts[:'timeout'].nil?
      query_params[:'js'] = opts[:'js'] if !opts[:'js'].nil?
      query_params[:'proxy'] = opts[:'proxy'] if !opts[:'proxy'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/html'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json', 'application/x-www-form-urlencoded', 'application/xml', 'text/plain'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'request_body']) 

      # return_type
      return_type = opts[:return_type] 

      # auth_names
      auth_names = opts[:auth_names] || ['api_key']

      new_options = opts.merge(
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: HTMLApi#post_html\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
