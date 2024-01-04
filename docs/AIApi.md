# WebScrapingAI::AIApi

All URIs are relative to *https://api.webscraping.ai*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_question**](AIApi.md#get_question) | **GET** /ai/question | Get an answer to a question about a given web page |


## get_question

> String get_question(url, opts)

Get an answer to a question about a given web page

Returns the answer in plain text. Proxies and Chromium JavaScript rendering are used for page retrieval and processing, then the answer is extracted using an LLM model.

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

api_instance = WebScrapingAI::AIApi.new
url = 'https://example.com' # String | URL of the target page.
opts = {
  question: 'What is the summary of this page content?', # String | Question or instructions to ask the LLM model about the target page.
  context_limit: 4000, # Integer | Maximum number of tokens to use as context for the LLM model (4000 by default).
  response_tokens: 100, # Integer | Maximum number of tokens to return in the LLM model response. The total context size (context_limit) includes the question, the target page content and the response, so this parameter reserves tokens for the response (see also on_context_limit).
  on_context_limit: 'truncate', # String | What to do if the context_limit parameter is exceeded (truncate by default). The context is exceeded when the target page content is too long.
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
  # Get an answer to a question about a given web page
  result = api_instance.get_question(url, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Error when calling AIApi->get_question: #{e}"
end
```

#### Using the get_question_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(String, Integer, Hash)> get_question_with_http_info(url, opts)

```ruby
begin
  # Get an answer to a question about a given web page
  data, status_code, headers = api_instance.get_question_with_http_info(url, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => String
rescue WebScrapingAI::ApiError => e
  puts "Error when calling AIApi->get_question_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **url** | **String** | URL of the target page. |  |
| **question** | **String** | Question or instructions to ask the LLM model about the target page. | [optional] |
| **context_limit** | **Integer** | Maximum number of tokens to use as context for the LLM model (4000 by default). | [optional][default to 4000] |
| **response_tokens** | **Integer** | Maximum number of tokens to return in the LLM model response. The total context size (context_limit) includes the question, the target page content and the response, so this parameter reserves tokens for the response (see also on_context_limit). | [optional][default to 100] |
| **on_context_limit** | **String** | What to do if the context_limit parameter is exceeded (truncate by default). The context is exceeded when the target page content is too long. | [optional][default to &#39;error&#39;] |
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

