# WebScrapingAI::Error

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** | Error description | [optional] |
| **status_code** | **Integer** | Target page response HTTP status code (403, 500, etc) | [optional] |
| **status_message** | **String** | Target page response HTTP status message | [optional] |
| **body** | **String** | Target page response body | [optional] |

## Example

```ruby
require 'webscraping_ai'

instance = WebScrapingAI::Error.new(
  message: null,
  status_code: null,
  status_message: null,
  body: null
)
```

