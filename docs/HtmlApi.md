# WebScrapingAI::HTMLApi

All URIs are relative to *https://api.webscraping.ai*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_html**](HTMLApi.md#get_html) | **GET** /html | Page HTML by URL
[**post_html**](HTMLApi.md#post_html) | **POST** /html | Page HTML by URL with POST request to the target page



## get_html

> get_html(url, opts)

Page HTML by URL

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

api_instance = WebScrapingAI::HTMLApi.new
url = 'https://example.com' # String | URL of the target page
opts = {
  headers: {'key' => '{\"Cookie\":\"session=some_id\"}'}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"})
  timeout: 5000, # Integer | Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
  proxy: 'datacenter' # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
}

begin
  #Page HTML by URL
  api_instance.get_html(url, opts)
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling HTMLApi->get_html: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| URL of the target page | 
 **headers** | [**Hash&lt;String, String&gt;**](String.md)| HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}) | [optional] 
 **timeout** | **Integer**| Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) | [optional] [default to 5000]
 **js** | **Boolean**| Execute on-page JavaScript using a headless browser (true by default), costs 2 requests | [optional] [default to true]
 **proxy** | **String**| Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) | [optional] [default to &#39;datacenter&#39;]

### Return type

nil (empty response body)

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/html


## post_html

> post_html(url, opts)

Page HTML by URL with POST request to the target page

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

api_instance = WebScrapingAI::HTMLApi.new
url = 'https://example.com' # String | URL of the target page
opts = {
  headers: {'key' => '{\"Cookie\":\"session=some_id\"}'}, # Hash<String, String> | HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers=[Another]=value2) or as a JSON encoded object (...&headers={\"One\": \"value1\", \"Another\": \"value2\"})
  timeout: 5000, # Integer | Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000)
  js: true, # Boolean | Execute on-page JavaScript using a headless browser (true by default), costs 2 requests
  proxy: 'datacenter' # String | Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default)
}

begin
  #Page HTML by URL with POST request to the target page
  api_instance.post_html(url, opts)
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling HTMLApi->post_html: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| URL of the target page | 
 **headers** | [**Hash&lt;String, String&gt;**](String.md)| HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&amp;headers[One]&#x3D;value1&amp;headers&#x3D;[Another]&#x3D;value2) or as a JSON encoded object (...&amp;headers&#x3D;{\&quot;One\&quot;: \&quot;value1\&quot;, \&quot;Another\&quot;: \&quot;value2\&quot;}) | [optional] 
 **timeout** | **Integer**| Maximum processing time in ms. Increase it in case of timeout errors (5000 by default, maximum is 30000) | [optional] [default to 5000]
 **js** | **Boolean**| Execute on-page JavaScript using a headless browser (true by default), costs 2 requests | [optional] [default to true]
 **proxy** | **String**| Type of proxy, use residential proxies if your site restricts traffic from datacenters (datacenter by default) | [optional] [default to &#39;datacenter&#39;]

### Return type

nil (empty response body)

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/html

