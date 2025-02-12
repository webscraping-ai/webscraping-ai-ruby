=begin
#WebScraping.AI

#WebScraping.AI scraping API provides LLM-powered tools with Chromium JavaScript rendering, rotating proxies, and built-in HTML parsing.

The version of the OpenAPI document: 3.2.0
Contact: support@webscraping.ai
Generated by: https://openapi-generator.tech
Generator version: 7.11.0

=end

require 'cgi'

module WebScrapingAI
  class SelectedHTMLApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # HTML of a selected page area by URL and CSS selector
    # Returns HTML of a selected page area by URL and CSS selector. Useful if you don't want to do the HTML parsing on your side.
    # @param url [String] URL of the target page.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :selector CSS selector (null by default, returns whole page HTML)
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}).
    # @option opts [Integer] :timeout Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). (default to 10000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default). (default to true)
    # @option opts [Integer] :js_timeout Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. (default to 2000)
    # @option opts [String] :wait_for CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout.
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. (default to 'datacenter')
    # @option opts [String] :country Country of the proxy to use (US by default). (default to 'us')
    # @option opts [String] :custom_proxy Your own proxy URL to use instead of our built-in proxy pool in \&quot;http://user:password@host:port\&quot; format (&lt;a target&#x3D;\&quot;_blank\&quot; href&#x3D;\&quot;https://webscraping.ai/proxies/smartproxy\&quot;&gt;Smartproxy&lt;/a&gt; for example).
    # @option opts [String] :device Type of device emulation. (default to 'desktop')
    # @option opts [Boolean] :error_on_404 Return error on 404 HTTP status on the target page (false by default). (default to false)
    # @option opts [Boolean] :error_on_redirect Return error on redirect on the target page (false by default). (default to false)
    # @option opts [String] :js_script Custom JavaScript code to execute on the target page.
    # @option opts [String] :format Format of the response (text by default). \&quot;json\&quot; will return a JSON object with the response, \&quot;text\&quot; will return a plain text/HTML response. (default to 'json')
    # @return [String]
    def get_selected(url, opts = {})
      data, _status_code, _headers = get_selected_with_http_info(url, opts)
      data
    end

    # HTML of a selected page area by URL and CSS selector
    # Returns HTML of a selected page area by URL and CSS selector. Useful if you don&#39;t want to do the HTML parsing on your side.
    # @param url [String] URL of the target page.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :selector CSS selector (null by default, returns whole page HTML)
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}).
    # @option opts [Integer] :timeout Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). (default to 10000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default). (default to true)
    # @option opts [Integer] :js_timeout Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. (default to 2000)
    # @option opts [String] :wait_for CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout.
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. (default to 'datacenter')
    # @option opts [String] :country Country of the proxy to use (US by default). (default to 'us')
    # @option opts [String] :custom_proxy Your own proxy URL to use instead of our built-in proxy pool in \&quot;http://user:password@host:port\&quot; format (&lt;a target&#x3D;\&quot;_blank\&quot; href&#x3D;\&quot;https://webscraping.ai/proxies/smartproxy\&quot;&gt;Smartproxy&lt;/a&gt; for example).
    # @option opts [String] :device Type of device emulation. (default to 'desktop')
    # @option opts [Boolean] :error_on_404 Return error on 404 HTTP status on the target page (false by default). (default to false)
    # @option opts [Boolean] :error_on_redirect Return error on redirect on the target page (false by default). (default to false)
    # @option opts [String] :js_script Custom JavaScript code to execute on the target page.
    # @option opts [String] :format Format of the response (text by default). \&quot;json\&quot; will return a JSON object with the response, \&quot;text\&quot; will return a plain text/HTML response. (default to 'json')
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def get_selected_with_http_info(url, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SelectedHTMLApi.get_selected ...'
      end
      # verify the required parameter 'url' is set
      if @api_client.config.client_side_validation && url.nil?
        fail ArgumentError, "Missing the required parameter 'url' when calling SelectedHTMLApi.get_selected"
      end
      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] > 30000
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling SelectedHTMLApi.get_selected, must be smaller than or equal to 30000.'
      end

      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling SelectedHTMLApi.get_selected, must be greater than or equal to 1.'
      end

      if @api_client.config.client_side_validation && !opts[:'js_timeout'].nil? && opts[:'js_timeout'] > 20000
        fail ArgumentError, 'invalid value for "opts[:"js_timeout"]" when calling SelectedHTMLApi.get_selected, must be smaller than or equal to 20000.'
      end

      if @api_client.config.client_side_validation && !opts[:'js_timeout'].nil? && opts[:'js_timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"js_timeout"]" when calling SelectedHTMLApi.get_selected, must be greater than or equal to 1.'
      end

      allowable_values = ["datacenter", "residential"]
      if @api_client.config.client_side_validation && opts[:'proxy'] && !allowable_values.include?(opts[:'proxy'])
        fail ArgumentError, "invalid value for \"proxy\", must be one of #{allowable_values}"
      end
      allowable_values = ["us", "gb", "de", "it", "fr", "ca", "es", "ru", "jp", "kr", "in"]
      if @api_client.config.client_side_validation && opts[:'country'] && !allowable_values.include?(opts[:'country'])
        fail ArgumentError, "invalid value for \"country\", must be one of #{allowable_values}"
      end
      allowable_values = ["desktop", "mobile", "tablet"]
      if @api_client.config.client_side_validation && opts[:'device'] && !allowable_values.include?(opts[:'device'])
        fail ArgumentError, "invalid value for \"device\", must be one of #{allowable_values}"
      end
      allowable_values = ["json", "text"]
      if @api_client.config.client_side_validation && opts[:'format'] && !allowable_values.include?(opts[:'format'])
        fail ArgumentError, "invalid value for \"format\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/selected'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'url'] = url
      query_params[:'selector'] = opts[:'selector'] if !opts[:'selector'].nil?
      query_params[:'headers'] = opts[:'headers'] if !opts[:'headers'].nil?
      query_params[:'timeout'] = opts[:'timeout'] if !opts[:'timeout'].nil?
      query_params[:'js'] = opts[:'js'] if !opts[:'js'].nil?
      query_params[:'js_timeout'] = opts[:'js_timeout'] if !opts[:'js_timeout'].nil?
      query_params[:'wait_for'] = opts[:'wait_for'] if !opts[:'wait_for'].nil?
      query_params[:'proxy'] = opts[:'proxy'] if !opts[:'proxy'].nil?
      query_params[:'country'] = opts[:'country'] if !opts[:'country'].nil?
      query_params[:'custom_proxy'] = opts[:'custom_proxy'] if !opts[:'custom_proxy'].nil?
      query_params[:'device'] = opts[:'device'] if !opts[:'device'].nil?
      query_params[:'error_on_404'] = opts[:'error_on_404'] if !opts[:'error_on_404'].nil?
      query_params[:'error_on_redirect'] = opts[:'error_on_redirect'] if !opts[:'error_on_redirect'].nil?
      query_params[:'js_script'] = opts[:'js_script'] if !opts[:'js_script'].nil?
      query_params[:'format'] = opts[:'format'] if !opts[:'format'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/html']) unless header_params['Accept']

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'String'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['api_key']

      new_options = opts.merge(
        :operation => :"SelectedHTMLApi.get_selected",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SelectedHTMLApi#get_selected\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # HTML of multiple page areas by URL and CSS selectors
    # Returns HTML of multiple page areas by URL and CSS selectors. Useful if you don't want to do the HTML parsing on your side.
    # @param url [String] URL of the target page.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :selectors Multiple CSS selectors (null by default, returns whole page HTML)
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}).
    # @option opts [Integer] :timeout Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). (default to 10000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default). (default to true)
    # @option opts [Integer] :js_timeout Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. (default to 2000)
    # @option opts [String] :wait_for CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout.
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. (default to 'datacenter')
    # @option opts [String] :country Country of the proxy to use (US by default). (default to 'us')
    # @option opts [String] :custom_proxy Your own proxy URL to use instead of our built-in proxy pool in \&quot;http://user:password@host:port\&quot; format (&lt;a target&#x3D;\&quot;_blank\&quot; href&#x3D;\&quot;https://webscraping.ai/proxies/smartproxy\&quot;&gt;Smartproxy&lt;/a&gt; for example).
    # @option opts [String] :device Type of device emulation. (default to 'desktop')
    # @option opts [Boolean] :error_on_404 Return error on 404 HTTP status on the target page (false by default). (default to false)
    # @option opts [Boolean] :error_on_redirect Return error on redirect on the target page (false by default). (default to false)
    # @option opts [String] :js_script Custom JavaScript code to execute on the target page.
    # @return [Array<String>]
    def get_selected_multiple(url, opts = {})
      data, _status_code, _headers = get_selected_multiple_with_http_info(url, opts)
      data
    end

    # HTML of multiple page areas by URL and CSS selectors
    # Returns HTML of multiple page areas by URL and CSS selectors. Useful if you don&#39;t want to do the HTML parsing on your side.
    # @param url [String] URL of the target page.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :selectors Multiple CSS selectors (null by default, returns whole page HTML)
    # @option opts [Hash<String, String>] :headers HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}).
    # @option opts [Integer] :timeout Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). (default to 10000)
    # @option opts [Boolean] :js Execute on-page JavaScript using a headless browser (true by default). (default to true)
    # @option opts [Integer] :js_timeout Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. (default to 2000)
    # @option opts [String] :wait_for CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout.
    # @option opts [String] :proxy Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. (default to 'datacenter')
    # @option opts [String] :country Country of the proxy to use (US by default). (default to 'us')
    # @option opts [String] :custom_proxy Your own proxy URL to use instead of our built-in proxy pool in \&quot;http://user:password@host:port\&quot; format (&lt;a target&#x3D;\&quot;_blank\&quot; href&#x3D;\&quot;https://webscraping.ai/proxies/smartproxy\&quot;&gt;Smartproxy&lt;/a&gt; for example).
    # @option opts [String] :device Type of device emulation. (default to 'desktop')
    # @option opts [Boolean] :error_on_404 Return error on 404 HTTP status on the target page (false by default). (default to false)
    # @option opts [Boolean] :error_on_redirect Return error on redirect on the target page (false by default). (default to false)
    # @option opts [String] :js_script Custom JavaScript code to execute on the target page.
    # @return [Array<(Array<String>, Integer, Hash)>] Array<String> data, response status code and response headers
    def get_selected_multiple_with_http_info(url, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SelectedHTMLApi.get_selected_multiple ...'
      end
      # verify the required parameter 'url' is set
      if @api_client.config.client_side_validation && url.nil?
        fail ArgumentError, "Missing the required parameter 'url' when calling SelectedHTMLApi.get_selected_multiple"
      end
      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] > 30000
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling SelectedHTMLApi.get_selected_multiple, must be smaller than or equal to 30000.'
      end

      if @api_client.config.client_side_validation && !opts[:'timeout'].nil? && opts[:'timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"timeout"]" when calling SelectedHTMLApi.get_selected_multiple, must be greater than or equal to 1.'
      end

      if @api_client.config.client_side_validation && !opts[:'js_timeout'].nil? && opts[:'js_timeout'] > 20000
        fail ArgumentError, 'invalid value for "opts[:"js_timeout"]" when calling SelectedHTMLApi.get_selected_multiple, must be smaller than or equal to 20000.'
      end

      if @api_client.config.client_side_validation && !opts[:'js_timeout'].nil? && opts[:'js_timeout'] < 1
        fail ArgumentError, 'invalid value for "opts[:"js_timeout"]" when calling SelectedHTMLApi.get_selected_multiple, must be greater than or equal to 1.'
      end

      allowable_values = ["datacenter", "residential"]
      if @api_client.config.client_side_validation && opts[:'proxy'] && !allowable_values.include?(opts[:'proxy'])
        fail ArgumentError, "invalid value for \"proxy\", must be one of #{allowable_values}"
      end
      allowable_values = ["us", "gb", "de", "it", "fr", "ca", "es", "ru", "jp", "kr", "in"]
      if @api_client.config.client_side_validation && opts[:'country'] && !allowable_values.include?(opts[:'country'])
        fail ArgumentError, "invalid value for \"country\", must be one of #{allowable_values}"
      end
      allowable_values = ["desktop", "mobile", "tablet"]
      if @api_client.config.client_side_validation && opts[:'device'] && !allowable_values.include?(opts[:'device'])
        fail ArgumentError, "invalid value for \"device\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/selected-multiple'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'url'] = url
      query_params[:'selectors'] = @api_client.build_collection_param(opts[:'selectors'], :multi) if !opts[:'selectors'].nil?
      query_params[:'headers'] = opts[:'headers'] if !opts[:'headers'].nil?
      query_params[:'timeout'] = opts[:'timeout'] if !opts[:'timeout'].nil?
      query_params[:'js'] = opts[:'js'] if !opts[:'js'].nil?
      query_params[:'js_timeout'] = opts[:'js_timeout'] if !opts[:'js_timeout'].nil?
      query_params[:'wait_for'] = opts[:'wait_for'] if !opts[:'wait_for'].nil?
      query_params[:'proxy'] = opts[:'proxy'] if !opts[:'proxy'].nil?
      query_params[:'country'] = opts[:'country'] if !opts[:'country'].nil?
      query_params[:'custom_proxy'] = opts[:'custom_proxy'] if !opts[:'custom_proxy'].nil?
      query_params[:'device'] = opts[:'device'] if !opts[:'device'].nil?
      query_params[:'error_on_404'] = opts[:'error_on_404'] if !opts[:'error_on_404'].nil?
      query_params[:'error_on_redirect'] = opts[:'error_on_redirect'] if !opts[:'error_on_redirect'].nil?
      query_params[:'js_script'] = opts[:'js_script'] if !opts[:'js_script'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json']) unless header_params['Accept']

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'Array<String>'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['api_key']

      new_options = opts.merge(
        :operation => :"SelectedHTMLApi.get_selected_multiple",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SelectedHTMLApi#get_selected_multiple\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
