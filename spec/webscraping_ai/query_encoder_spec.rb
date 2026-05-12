RSpec.describe WebScrapingAI::QueryEncoder do
  describe ".encode" do
    it "encodes scalars as key=value" do
      expect(described_class.encode(url: "https://example.com", timeout: 5000))
        .to eq("url=https%3A%2F%2Fexample.com&timeout=5000")
    end

    it "encodes booleans as the strings true/false" do
      expect(described_class.encode(js: true, error_on_redirect: false))
        .to eq("js=true&error_on_redirect=false")
    end

    it "encodes a Hash as deepObject (key[sub]=value)" do
      result = described_class.encode(headers: { "Cookie" => "session=abc", "X-Foo" => "bar" })
      expect(result).to include("headers[Cookie]=session%3Dabc")
      expect(result).to include("headers[X-Foo]=bar")
    end

    it "encodes an Array as repeated form params (key=v1&key=v2)" do
      expect(described_class.encode(selectors: ["h1", ".price"]))
        .to eq("selectors=h1&selectors=.price")
    end

    it "drops top-level nil values entirely" do
      expect(described_class.encode(url: "https://example.com", selector: nil))
        .to eq("url=https%3A%2F%2Fexample.com")
    end

    it "drops nil values inside hashes" do
      expect(described_class.encode(headers: { "A" => "1", "B" => nil }))
        .to eq("headers[A]=1")
    end

    it "drops nil values inside arrays" do
      expect(described_class.encode(selectors: ["h1", nil, ".price"]))
        .to eq("selectors=h1&selectors=.price")
    end

    it "returns an empty string for an empty hash" do
      expect(described_class.encode({})).to eq("")
    end

    it "returns nil for nil input" do
      expect(described_class.encode(nil)).to be_nil
    end

    it "url-encodes special characters in keys and values (spaces as %20, not +)" do
      result = described_class.encode(fields: { "Main Title" => "Product's name" })
      expect(result).to eq("fields[Main%20Title]=Product%27s%20name")
    end
  end

  describe ".decode" do
    it "returns nil for nil input" do
      expect(described_class.decode(nil)).to be_nil
    end

    it "decodes a simple query string into key/value pairs" do
      expect(described_class.decode("a=1&b=2")).to eq([%w[a 1], %w[b 2]])
    end
  end
end
