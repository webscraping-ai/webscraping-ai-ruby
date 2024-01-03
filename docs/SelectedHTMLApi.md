# WebScrapingAI::SelectedHTMLApi

All URIs are relative to *https://api.webscraping.ai*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_selected**](SelectedHTMLApi.md#get_selected) | **GET** /selected | HTML of a selected page area by URL and CSS selector |
| [**get_selected_multiple**](SelectedHTMLApi.md#get_selected_multiple) | **GET** /selected-multiple | HTML of multiple page areas by URL and CSS selectors |


## get_selected

> String get_selected(url, opts)

HTML of a selected page area by URL and CSS selector

Returns HTML of a selected page area by URL and CSS selector. Useful if you don't want to do the HTML parsing on your side.

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

api_instance = WebScrapingAI::SelectedHTMLApi.new
url = 'https://example.com' # String | URL of the target page.
opts = {
  selector: 'h1', # String | CSS selector (null by default, returns whole page HTML)
  headers: { key: 3.56}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"}).
  timeout: 10000, # Integer | Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000).
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default).
  js_timeout: 2000, # Integer | Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page.
  proxy: 'datacenter', # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details.
  country: 'us', # String | Country of the proxy to use (US by default). Only available on Startup and Custom plans.
  device: 'desktop', # String | Type of device emulation.
  error_on_404: false, # Boolean | Return error on 404 HTTP status on the target page (false by default).
  error_on_redirect: false, # Boolean | Return error on redirect on the target page (false by default).
  js_script: 'document.querySelector('button').click();' # String | Custom JavaScript code to execute on the target page.
}

begin
  # HTML of a selected page area by URL and CSS selector
  result = api_instance.get_selected(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Error when calling SelectedHTMLApi->get_selected: #{e}"
end
```

#### Using the get_selected_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(String, Integer, Hash)> get_selected_with_http_info(url, opts)

```ruby
begin
  # HTML of a selected page area by URL and CSS selector
  data, status_code, headers = api_instance.get_selected_with_http_info(url, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => String
rescue WebScrapingAI::ApiError => e
  puts "Error when calling SelectedHTMLApi->get_selected_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **url** | **String** | URL of the target page. |  |
| **selector** | **String** | CSS selector (null by default, returns whole page HTML) | [optional] |
| **headers** | [**Hash&lt;String, String&gt;**](String.md) | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}). | [optional] |
| **timeout** | **Integer** | Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). | [optional][default to 10000] |
| **js** | **Boolean** | Execute on-page JavaScript using a headless browser (true by default). | [optional][default to true] |
| **js_timeout** | **Integer** | Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. | [optional][default to 2000] |
| **proxy** | **String** | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. | [optional][default to &#39;datacenter&#39;] |
| **country** | **String** | Country of the proxy to use (US by default). Only available on Startup and Custom plans. | [optional][default to &#39;us&#39;] |
| **device** | **String** | Type of device emulation. | [optional][default to &#39;desktop&#39;] |
| **error_on_404** | **Boolean** | Return error on 404 HTTP status on the target page (false by default). | [optional][default to false] |
| **error_on_redirect** | **Boolean** | Return error on redirect on the target page (false by default). | [optional][default to false] |
| **js_script** | **String** | Custom JavaScript code to execute on the target page. | [optional] |

### Return type

**String**

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/html


## get_selected_multiple

> Array&lt;String&gt; get_selected_multiple(url, opts)

HTML of multiple page areas by URL and CSS selectors

Returns HTML of multiple page areas by URL and CSS selectors. Useful if you don't want to do the HTML parsing on your side.

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

api_instance = WebScrapingAI::SelectedHTMLApi.new
url = 'https://example.com' # String | URL of the target page.
opts = {
  selectors: ['inner_example'], # Array<String> | Multiple CSS selectors (null by default, returns whole page HTML)
  headers: { key: 3.56}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"}).
  timeout: 10000, # Integer | Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000).
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default).
  js_timeout: 2000, # Integer | Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page.
  proxy: 'datacenter', # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details.
  country: 'us', # String | Country of the proxy to use (US by default). Only available on Startup and Custom plans.
  device: 'desktop', # String | Type of device emulation.
  error_on_404: false, # Boolean | Return error on 404 HTTP status on the target page (false by default).
  error_on_redirect: false, # Boolean | Return error on redirect on the target page (false by default).
  js_script: 'document.querySelector('button').click();' # String | Custom JavaScript code to execute on the target page.
}

begin
  # HTML of multiple page areas by URL and CSS selectors
  result = api_instance.get_selected_multiple(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Error when calling SelectedHTMLApi->get_selected_multiple: #{e}"
end
```

#### Using the get_selected_multiple_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(Array&lt;String&gt;, Integer, Hash)> get_selected_multiple_with_http_info(url, opts)

```ruby
begin
  # HTML of multiple page areas by URL and CSS selectors
  data, status_code, headers = api_instance.get_selected_multiple_with_http_info(url, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => Array&lt;String&gt;
rescue WebScrapingAI::ApiError => e
  puts "Error when calling SelectedHTMLApi->get_selected_multiple_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **url** | **String** | URL of the target page. |  |
| **selectors** | [**Array&lt;String&gt;**](String.md) | Multiple CSS selectors (null by default, returns whole page HTML) | [optional] |
| **headers** | [**Hash&lt;String, String&gt;**](String.md) | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}). | [optional] |
| **timeout** | **Integer** | Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 30000). | [optional][default to 10000] |
| **js** | **Boolean** | Execute on-page JavaScript using a headless browser (true by default). | [optional][default to true] |
| **js_timeout** | **Integer** | Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page. | [optional][default to 2000] |
| **proxy** | **String** | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default). Note that residential proxy requests are more expensive than datacenter, see the pricing page for details. | [optional][default to &#39;datacenter&#39;] |
| **country** | **String** | Country of the proxy to use (US by default). Only available on Startup and Custom plans. | [optional][default to &#39;us&#39;] |
| **device** | **String** | Type of device emulation. | [optional][default to &#39;desktop&#39;] |
| **error_on_404** | **Boolean** | Return error on 404 HTTP status on the target page (false by default). | [optional][default to false] |
| **error_on_redirect** | **Boolean** | Return error on redirect on the target page (false by default). | [optional][default to false] |
| **js_script** | **String** | Custom JavaScript code to execute on the target page. | [optional] |

### Return type

**Array&lt;String&gt;**

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

