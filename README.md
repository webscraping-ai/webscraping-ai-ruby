# webscraping_ai

WebScrapingAI - the Ruby gem for the WebScraping.AI

A client for https://webscraping.ai API. It provides Chrome JS rendering, rotating proxies and HTML parsing for web scraping.

This SDK is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 1.0.0
- Package version: 1.0.0
- Build package: org.openapitools.codegen.languages.RubyClientCodegen

## Installation

### Install from RubyGems

Add the following in the Gemfile:

    gem 'webscraping_ai'

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:

```ruby
# Load the gem
require 'webscraping_ai'

# Setup authorization
WebScrapingAI.configure do |config|
  # Configure API key authorization: api_key
  config.api_key['api_key'] = 'test-api-key'
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

## Documentation for API Endpoints

All URIs are relative to *https://webscraping.ai/api*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*WebScrapingAI::HtmlApi* | [**get_page**](docs/HtmlApi.md#get_page) | **GET** / | Get page HTML by URL (renders JS in Chrome and uses rotating proxies)


## Documentation for Models

 - [WebScrapingAI::ScrappedPage](docs/ScrappedPage.md)


## Documentation for Authorization


### api_key


- **Type**: API key
- **API key parameter name**: api_key
- **Location**: URL query string

