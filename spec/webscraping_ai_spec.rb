RSpec.describe WebScrapingAI do
  it "has a version number" do
    expect(WebScrapingAI::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end

  describe ".configure" do
    it "yields the configuration object" do
      described_class.configure do |config|
        config.api_key = "test-key"
        config.timeout = 5
      end

      expect(described_class.configuration.api_key).to eq("test-key")
      expect(described_class.configuration.timeout).to eq(5)
    end

    it "returns the configuration" do
      result = described_class.configure { |c| c.api_key = "k" }
      expect(result).to be(described_class.configuration)
    end
  end

  describe ".reset_configuration!" do
    it "restores defaults" do
      described_class.configure { |c| c.api_key = "old" }
      described_class.reset_configuration!
      expect(described_class.configuration.api_key).to be_nil
      expect(described_class.configuration.base_url).to eq(WebScrapingAI::Configuration::DEFAULT_BASE_URL)
    end
  end
end
