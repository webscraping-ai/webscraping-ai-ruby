# WebScrapingAI::Account

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **email** | **String** | Your account email | [optional] |
| **remaining_api_calls** | **Integer** | Remaining API credits quota | [optional] |
| **resets_at** | **Integer** | Next billing cycle start time (UNIX timestamp) | [optional] |
| **remaining_concurrency** | **Integer** | Remaining concurrent requests | [optional] |

## Example

```ruby
require 'webscraping_ai'

instance = WebScrapingAI::Account.new(
  email: null,
  remaining_api_calls: null,
  resets_at: null,
  remaining_concurrency: null
)
```

