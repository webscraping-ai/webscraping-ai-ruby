# webscraping_ai

WebScrapingAI - the Ruby gem for the WebScraping.AI

WebScraping.AI scraping API provides LLM-powered tools with Chromium JavaScript rendering, rotating proxies, and built-in HTML parsing.

This SDK is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 3.2.0
- Package version: 3.2.0
- Generator version: 7.11.0
- Build package: org.openapitools.codegen.languages.RubyClientCodegen
For more information, please visit [https://webscraping.ai](https://webscraping.ai)

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build webscraping_ai.gemspec
```

Then either install the gem locally:

```shell
gem install ./webscraping_ai-3.2.0.gem
```

(for development, run `gem install --dev ./webscraping_ai-3.2.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'webscraping_ai', '~> 3.2.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/webscraping-ai/webscraping-ai-ruby, then add the following in the Gemfile:

    gem 'webscraping_ai', :git => 'https://github.com/webscraping-ai/webscraping-ai-ruby.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:

```ruby
# Load the gem
require 'webscraping_ai'

# Setup authorization
WebScrapingAI.configure do |config|
  # Configure API key authorization: api_key
  config.api_key['api_key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['api_key'] = 'Bearer'
end

api_instance = WebScrapingAI::AIApi.new
url = 'https://example.com' # String | URL of the target page.
fields = { key: { key: 'inner_example'}} # Hash<String, String> | Object describing fields to extract from the page and their descriptions
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
  js_script: 'document.querySelector('button').click();' # String | Custom JavaScript code to execute on the target page.
}

begin
  #Extract structured data fields from a web page
  result = api_instance.get_fields(url, fields, opts)
  p result
rescue WebScrapingAI::ApiError => e
  puts "Exception when calling AIApi->get_fields: #{e}"
end

```

## Documentation for API Endpoints

All URIs are relative to *https://api.webscraping.ai*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*WebScrapingAI::AIApi* | [**get_fields**](docs/AIApi.md#get_fields) | **GET** /ai/fields | Extract structured data fields from a web page
*WebScrapingAI::AIApi* | [**get_question**](docs/AIApi.md#get_question) | **GET** /ai/question | Get an answer to a question about a given web page
*WebScrapingAI::AccountApi* | [**account**](docs/AccountApi.md#account) | **GET** /account | Information about your account calls quota
*WebScrapingAI::HTMLApi* | [**get_html**](docs/HTMLApi.md#get_html) | **GET** /html | Page HTML by URL
*WebScrapingAI::SelectedHTMLApi* | [**get_selected**](docs/SelectedHTMLApi.md#get_selected) | **GET** /selected | HTML of a selected page area by URL and CSS selector
*WebScrapingAI::SelectedHTMLApi* | [**get_selected_multiple**](docs/SelectedHTMLApi.md#get_selected_multiple) | **GET** /selected-multiple | HTML of multiple page areas by URL and CSS selectors
*WebScrapingAI::TextApi* | [**get_text**](docs/TextApi.md#get_text) | **GET** /text | Page text by URL


## Documentation for Models

 - [WebScrapingAI::Account](docs/Account.md)
 - [WebScrapingAI::Error](docs/Error.md)


## Documentation for Authorization


Authentication schemes defined for the API:
### api_key


- **Type**: API key
- **API key parameter name**: api_key
- **Location**: URL query string

