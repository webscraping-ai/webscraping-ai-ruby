=begin
#WebScraping.AI

#A client for https://webscraping.ai API. It provides a web scaping automation API with Chrome JS rendering, rotating proxies and builtin HTML parsing.

The version of the OpenAPI document: 2.0.0
Contact: support@webscraping.ai
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 4.3.1

=end

# Common files
require 'webscraping_ai/api_client'
require 'webscraping_ai/api_error'
require 'webscraping_ai/version'
require 'webscraping_ai/configuration'

# Models
require 'webscraping_ai/models/error'
require 'webscraping_ai/models/page_error'

# APIs
require 'webscraping_ai/api/html_api'
require 'webscraping_ai/api/selected_html_api'

module WebScrapingAI
  class << self
    # Customize default settings for the SDK using block.
    #   WebScrapingAI.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end
