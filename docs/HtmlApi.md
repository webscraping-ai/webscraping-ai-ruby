# WebScrapingAI::HTMLApi

All URIs are relative to *https://api.webscraping.ai*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_html**](HTMLApi.md#get_html) | **GET** /html | Page HTML by URL |


## get_html

> String get_html(url, opts)

Page HTML by URL

Returns the full HTML content of a webpage specified by the URL. The response is in plain text. Proxies and Chromium JavaScript rendering are used for page retrieval and processing.

### Examples

```ruby
require 'time'
require 'webscraping_ai'
# setup authorization
WebScrapingAI.configure do |config|
  # Configure API key authorization: api_key
  config.api_key['api_key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['api_key'] = 'Bearer'
end

api_instance = WebScrapingAI::HTMLApi.new
url = 'https://example.com' # String | URL of the target page.
opts = {
  headers: { key: { key: 'inner_example'}}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"}).
  timeout: 10000, # Integer | Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000).
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default).
  js_timeout: 2000, # Integer | Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page.
  wait_for: 'wait_for_example', # String | CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout.
  proxy: 'datacenter', # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details.
  country: 'us', # String | Country of the proxy to use (US by default).
  custom_proxy: 'custom_proxy_example', # String | Your own proxy URL to use instead of our built-in proxy pool in \"http://user:password@host:port\" format (<a target=\"_blank\" href=\"https://webscraping.ai/proxies/smartproxy\">Smartproxy</a> for example).
  device: 'desktop', # String | Type of device emulation.
  error_on_404: false, # Boolean | Return error on 404 HTTP status on the target page (false by default).
  error_on_redirect: false, # Boolean | Return error on redirect on the target page (false by default).
  js_script: 'document.querySelector('button').click();', # String | Custom JavaScript code to execute on the target page.
  return_script_result: false, # Boolean | Return result of the custom JavaScript code (js_script parameter) execution on the target page (false by default, page HTML will be returned).
  format: 'json' # String | Format of the response (text by default). \"json\" will return a JSON object with the response, \"text\" will return a plain text/HTML response.
}

begin
  # Page HTML by URL
  result = api_instance.get_html(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Error when calling HTMLApi->get_html: #{e}"
end
```

#### Using the get_html_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(String, Integer, Hash)> get_html_with_http_info(url, opts)

```ruby
begin
  # Page HTML by URL
  data, status_code, headers = api_instance.get_html_with_http_info(url, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => String
rescue WebScrapingAI::ApiError => e
  puts "Error when calling HTMLApi->get_html_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **url** | **String** | URL of the target page. |  |
| **headers** | [**Hash&lt;String, String&gt;**](String.md) | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}). | [optional] |
| **timeout** | **Integer** | Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). | [optional][default to 10000] |
| **js** | **Boolean** | Execute on-page JavaScript using a headless browser (true by default). | [optional][default to true] |
| **js_timeout** | **Integer** | Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. | [optional][default to 2000] |
| **wait_for** | **String** | CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout. | [optional] |
| **proxy** | **String** | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. | [optional][default to &#39;datacenter&#39;] |
| **country** | **String** | Country of the proxy to use (US by default). | [optional][default to &#39;us&#39;] |
| **custom_proxy** | **String** | Your own proxy URL to use instead of our built-in proxy pool in \&quot;http://user:password@host:port\&quot; format (&lt;a target&#x3D;\&quot;_blank\&quot; href&#x3D;\&quot;https://webscraping.ai/proxies/smartproxy\&quot;&gt;Smartproxy&lt;/a&gt; for example). | [optional] |
| **device** | **String** | Type of device emulation. | [optional][default to &#39;desktop&#39;] |
| **error_on_404** | **Boolean** | Return error on 404 HTTP status on the target page (false by default). | [optional][default to false] |
| **error_on_redirect** | **Boolean** | Return error on redirect on the target page (false by default). | [optional][default to false] |
| **js_script** | **String** | Custom JavaScript code to execute on the target page. | [optional] |
| **return_script_result** | **Boolean** | Return result of the custom JavaScript code (js_script parameter) execution on the target page (false by default, page HTML will be returned). | [optional][default to false] |
| **format** | **String** | Format of the response (text by default). \&quot;json\&quot; will return a JSON object with the response, \&quot;text\&quot; will return a plain text/HTML response. | [optional][default to &#39;json&#39;] |

### Return type

**String**

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/html

