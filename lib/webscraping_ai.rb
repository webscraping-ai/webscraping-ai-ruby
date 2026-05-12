require "webscraping_ai/version"
require "webscraping_ai/errors"
require "webscraping_ai/configuration"
require "webscraping_ai/query_encoder"
require "webscraping_ai/client"

module WebScrapingAI
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
      configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
