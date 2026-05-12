module WebScrapingAI
  class Configuration
    DEFAULT_BASE_URL = "https://api.webscraping.ai".freeze
    DEFAULT_TIMEOUT = 60
    DEFAULT_OPEN_TIMEOUT = 10

    attr_accessor :api_key, :base_url, :timeout, :open_timeout, :adapter, :user_agent

    def initialize
      @api_key = ENV.fetch("WEBSCRAPING_AI_API_KEY", nil)
      @base_url = DEFAULT_BASE_URL
      @timeout = DEFAULT_TIMEOUT
      @open_timeout = DEFAULT_OPEN_TIMEOUT
      @adapter = nil
      @user_agent = "webscraping_ai-ruby/#{WebScrapingAI::VERSION}"
    end
  end
end
