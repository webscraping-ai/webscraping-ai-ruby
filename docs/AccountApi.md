# WebScrapingAI::AccountApi

All URIs are relative to *https://api.webscraping.ai*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**account**](AccountApi.md#account) | **GET** /account | Information about your account calls quota |


## account

> <Account> account

Information about your account calls quota

Returns information about your account, including the remaining API credits quota, the next billing cycle start time, and the remaining concurrent requests. The response is in JSON format.

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

api_instance = WebScrapingAI::AccountApi.new

begin
  # Information about your account calls quota
  result = api_instance.account
  p result
rescue WebScrapingAI::ApiError => e
  puts "Error when calling AccountApi->account: #{e}"
end
```

#### Using the account_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Account>, Integer, Hash)> account_with_http_info

```ruby
begin
  # Information about your account calls quota
  data, status_code, headers = api_instance.account_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Account>
rescue WebScrapingAI::ApiError => e
  puts "Error when calling AccountApi->account_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**Account**](Account.md)

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

