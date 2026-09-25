RSpec.describe WebScrapingAI::Configuration do
  describe "defaults" do
    it "uses the official API base URL" do
      expect(described_class.new.base_url).to eq("https://api.webscraping.ai")
    end

    it "defaults timeout to 60s" do
      expect(described_class.new.timeout).to eq(60)
    end

    it "defaults open_timeout to 10s" do
      expect(described_class.new.open_timeout).to eq(10)
    end

    it "sets a user agent tagged with the gem version" do
      expect(described_class.new.user_agent).to eq("webscraping_ai-ruby/#{WebScrapingAI::VERSION}")
    end

    it "reads api_key from WEBSCRAPING_AI_API_KEY when set" do
      original = ENV.fetch("WEBSCRAPING_AI_API_KEY", nil)
      ENV["WEBSCRAPING_AI_API_KEY"] = "env-key"
      begin
        expect(described_class.new.api_key).to eq("env-key")
      ensure
        ENV["WEBSCRAPING_AI_API_KEY"] = original
      end
    end

    it "leaves api_key nil when no env var is set" do
      original = ENV.delete("WEBSCRAPING_AI_API_KEY")
      begin
        expect(described_class.new.api_key).to be_nil
      ensure
        ENV["WEBSCRAPING_AI_API_KEY"] = original
      end
    end
  end

  describe "#inspect" do
    it "masks the API key" do
      config = described_class.new
      config.api_key = "super-secret-key"
      expect(config.inspect).not_to include("super-secret-key")
      expect(config.inspect).to include('api_key="[FILTERED]"')
      expect(config.inspect).to include("https://api.webscraping.ai")
    end

    it "shows nil when no key is set" do
      config = described_class.new
      config.api_key = nil
      expect(config.inspect).to include("api_key=nil")
    end
  end
end
