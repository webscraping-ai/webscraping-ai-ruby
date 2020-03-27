# WebScrapingAI::HtmlApi

All URIs are relative to *https://webscraping.ai/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_page**](HtmlApi.md#get_page) | **GET** / | Get page HTML by URL (renders JS in Chrome and uses rotating proxies)



## get_page

> ScrappedPage get_page(url, opts)

Get page HTML by URL (renders JS in Chrome and uses rotating proxies)

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

api_instance = WebScrapingAI::HtmlApi.new
url = 'https://example.com' # String | URL of the page to get
opts = {
  selector: 'html', # String | CSS selector to get a part of the page (null by default, returns whole page HTML)
  outer_html: false, # Boolean | Return outer HTML of the selected element (false by default, returns inner HTML)
  proxy: 'US', # String | Proxy country code, for geotargeting (US by default)
  disable_js: false, # Boolean | Disable JS execution (false by default)
  inline_css: false # Boolean | Inline included CSS files to make page viewable on other domains (false by default)
}

begin
  #Get page HTML by URL (renders JS in Chrome and uses rotating proxies)
  result = api_instance.get_page(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling HtmlApi->get_page: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| URL of the page to get | 
 **selector** | **String**| CSS selector to get a part of the page (null by default, returns whole page HTML) | [optional] 
 **outer_html** | **Boolean**| Return outer HTML of the selected element (false by default, returns inner HTML) | [optional] 
 **proxy** | **String**| Proxy country code, for geotargeting (US by default) | [optional] 
 **disable_js** | **Boolean**| Disable JS execution (false by default) | [optional] 
 **inline_css** | **Boolean**| Inline included CSS files to make page viewable on other domains (false by default) | [optional] 

### Return type

[**ScrappedPage**](ScrappedPage.md)

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

