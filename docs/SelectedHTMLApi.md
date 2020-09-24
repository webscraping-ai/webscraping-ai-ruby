# WebScrapingAI::SelectedHTMLApi

All URIs are relative to *https://api.webscraping.ai*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_selected**](SelectedHTMLApi.md#get_selected) | **GET** /selected | HTML of a selected page area by URL and CSS selector
[**get_selected_multiple**](SelectedHTMLApi.md#get_selected_multiple) | **GET** /selected-multiple | HTML of multiple page areas by URL and CSS selectors
[**post_selected**](SelectedHTMLApi.md#post_selected) | **POST** /selected | HTML of a selected page areas by URL and CSS selector, with POST request to the target page
[**post_selected_multiple**](SelectedHTMLApi.md#post_selected_multiple) | **POST** /selected-multiple | HTML of multiple page areas by URL and CSS selectors, with POST request to the target page



## get_selected

> String get_selected(url, opts)

HTML of a selected page area by URL and CSS selector

Returns just HTML on success, JSON on error

### Example

```ruby
# load the gem
require 'webscraping_ai'
# setup authorization
WebScrapingAI.configure do |config|
  # Configure API key authorization: api_key
  config.api_key['api_key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['api_key'] = 'Bearer'
end

api_instance = WebScrapingAI::SelectedHTMLApi.new
url = 'https://example.com' # String | URL of the target page
opts = {
  selector: 'h1', # String | CSS selector (null by default, returns whole page HTML)
  headers: {'key' => '{\"Cookie\":\"session=some_id\"}'}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"})
  timeout: 5000, # Integer | Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
  proxy: 'datacenter' # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
}

begin
  #HTML of a selected page area by URL and CSS selector
  result = api_instance.get_selected(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling SelectedHTMLApi->get_selected: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| URL of the target page | 
 **selector** | **String**| CSS selector (null by default, returns whole page HTML) | [optional] 
 **headers** | [**Hash&lt;String, String&gt;**](String.md)| HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}) | [optional] 
 **timeout** | **Integer**| Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) | [optional] [default to 5000]
 **js** | **Boolean**| Execute on-page JavaScript using a headless browser (true by default), costs 2 requests | [optional] [default to true]
 **proxy** | **String**| Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) | [optional] [default to &#39;datacenter&#39;]

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

Always returns JSON

### Example

```ruby
# load the gem
require 'webscraping_ai'
# setup authorization
WebScrapingAI.configure do |config|
  # Configure API key authorization: api_key
  config.api_key['api_key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['api_key'] = 'Bearer'
end

api_instance = WebScrapingAI::SelectedHTMLApi.new
url = 'https://example.com' # String | URL of the target page
opts = {
  selectors: ['[\"h1\"]'], # Array<String> | Multiple CSS selectors (null by default, returns whole page HTML)
  headers: {'key' => '{\"Cookie\":\"session=some_id\"}'}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"})
  timeout: 5000, # Integer | Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
  proxy: 'datacenter' # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
}

begin
  #HTML of multiple page areas by URL and CSS selectors
  result = api_instance.get_selected_multiple(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling SelectedHTMLApi->get_selected_multiple: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| URL of the target page | 
 **selectors** | [**Array&lt;String&gt;**](String.md)| Multiple CSS selectors (null by default, returns whole page HTML) | [optional] 
 **headers** | [**Hash&lt;String, String&gt;**](String.md)| HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}) | [optional] 
 **timeout** | **Integer**| Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) | [optional] [default to 5000]
 **js** | **Boolean**| Execute on-page JavaScript using a headless browser (true by default), costs 2 requests | [optional] [default to true]
 **proxy** | **String**| Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) | [optional] [default to &#39;datacenter&#39;]

### Return type

**Array&lt;String&gt;**

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## post_selected

> String post_selected(url, opts)

HTML of a selected page areas by URL and CSS selector, with POST request to the target page

Returns just HTML on success, JSON on error. Request body will be passed to the target page.

### Example

```ruby
# load the gem
require 'webscraping_ai'
# setup authorization
WebScrapingAI.configure do |config|
  # Configure API key authorization: api_key
  config.api_key['api_key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['api_key'] = 'Bearer'
end

api_instance = WebScrapingAI::SelectedHTMLApi.new
url = 'https://httpbin.org/post' # String | URL of the target page
opts = {
  selector: 'h1', # String | CSS selector (null by default, returns whole page HTML)
  headers: {'key' => '{\"Cookie\":\"session=some_id\"}'}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"})
  timeout: 5000, # Integer | Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
  proxy: 'datacenter', # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
  request_body: nil # Hash<String, Object> | Request body to pass to the target page
}

begin
  #HTML of a selected page areas by URL and CSS selector, with POST request to the target page
  result = api_instance.post_selected(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling SelectedHTMLApi->post_selected: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| URL of the target page | 
 **selector** | **String**| CSS selector (null by default, returns whole page HTML) | [optional] 
 **headers** | [**Hash&lt;String, String&gt;**](String.md)| HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}) | [optional] 
 **timeout** | **Integer**| Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) | [optional] [default to 5000]
 **js** | **Boolean**| Execute on-page JavaScript using a headless browser (true by default), costs 2 requests | [optional] [default to true]
 **proxy** | **String**| Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) | [optional] [default to &#39;datacenter&#39;]
 **request_body** | [**Hash&lt;String, Object&gt;**](Object.md)| Request body to pass to the target page | [optional] 

### Return type

**String**

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: application/json, application/x-www-form-urlencoded, application/xml, text/plain
- **Accept**: application/json, text/html


## post_selected_multiple

> Array&lt;String&gt; post_selected_multiple(url, opts)

HTML of multiple page areas by URL and CSS selectors, with POST request to the target page

Always returns JSON. Request body will be passed to the target page.

### Example

```ruby
# load the gem
require 'webscraping_ai'
# setup authorization
WebScrapingAI.configure do |config|
  # Configure API key authorization: api_key
  config.api_key['api_key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['api_key'] = 'Bearer'
end

api_instance = WebScrapingAI::SelectedHTMLApi.new
url = 'https://httpbin.org/post' # String | URL of the target page
opts = {
  selectors: ['[\"h1\"]'], # Array<String> | Multiple CSS selectors (null by default, returns whole page HTML)
  headers: {'key' => '{\"Cookie\":\"session=some_id\"}'}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"})
  timeout: 5000, # Integer | Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
  proxy: 'datacenter', # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
  request_body: nil # Hash<String, Object> | Request body to pass to the target page
}

begin
  #HTML of multiple page areas by URL and CSS selectors, with POST request to the target page
  result = api_instance.post_selected_multiple(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling SelectedHTMLApi->post_selected_multiple: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| URL of the target page | 
 **selectors** | [**Array&lt;String&gt;**](String.md)| Multiple CSS selectors (null by default, returns whole page HTML) | [optional] 
 **headers** | [**Hash&lt;String, String&gt;**](String.md)| HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}) | [optional] 
 **timeout** | **Integer**| Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) | [optional] [default to 5000]
 **js** | **Boolean**| Execute on-page JavaScript using a headless browser (true by default), costs 2 requests | [optional] [default to true]
 **proxy** | **String**| Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) | [optional] [default to &#39;datacenter&#39;]
 **request_body** | [**Hash&lt;String, Object&gt;**](Object.md)| Request body to pass to the target page | [optional] 

### Return type

**Array&lt;String&gt;**

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: application/json, application/x-www-form-urlencoded, application/xml, text/plain
- **Accept**: application/json

