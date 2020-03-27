# WebScrapingAI::ScrappedPage

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**size_bytes** | **Integer** | Page HTML content size in bytes | [optional] 
**html** | **String** | HTML of the full page or a selected area | [optional] 
**status** | **Integer** | Response HTTP status code (200, 404, 302, etc) | [optional] 
**status_message** | **String** | Response HTTP status message | [optional] 

## Code Sample

```ruby
require 'WebScrapingAI'

instance = WebScrapingAI::ScrappedPage.new(size_bytes: null,
                                 html: null,
                                 status: null,
                                 status_message: null)
```


