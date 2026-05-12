RSpec.describe WebScrapingAI::Client do
  let(:api_key) { "test-key" }
  let(:client) { described_class.new(api_key: api_key) }
  let(:base_url) { "https://api.webscraping.ai" }
  let(:target_url) { "https://example.com" }

  describe "#initialize" do
    it "uses an explicit api_key over the global configuration" do
      WebScrapingAI.configure { |c| c.api_key = "global" }
      expect(described_class.new(api_key: "explicit").configuration.api_key).to eq("explicit")
    end

    it "falls back to the global configuration when no api_key is given" do
      WebScrapingAI.configure { |c| c.api_key = "global" }
      expect(described_class.new.configuration.api_key).to eq("global")
    end

    it "raises ConfigurationError when no api_key is available" do
      expect { described_class.new }.to raise_error(WebScrapingAI::ConfigurationError, /api_key/)
    end

    it "raises ConfigurationError when api_key is empty" do
      expect { described_class.new(api_key: "") }.to raise_error(WebScrapingAI::ConfigurationError)
    end
  end

  describe "#account" do
    it "GETs /account and returns the parsed payload" do
      body = { remaining_api_calls: 200_000, resets_at: 1_617_073_667, remaining_concurrency: 100 }
      stub_request(:get, "#{base_url}/account")
        .with(query: { api_key: api_key })
        .to_return(status: 200, body: body.to_json, headers: { "content-type" => "application/json" })

      expect(client.account).to eq("remaining_api_calls" => 200_000, "resets_at" => 1_617_073_667,
                                   "remaining_concurrency" => 100)
    end
  end

  describe "#html" do
    it "GETs /html with url and api_key and returns the body string" do
      stub_request(:get, "#{base_url}/html")
        .with(query: { api_key: api_key, url: target_url })
        .to_return(status: 200, body: "<html>ok</html>", headers: { "content-type" => "text/html" })

      expect(client.html(target_url)).to eq("<html>ok</html>")
    end

    it "forwards page-fetch options and encodes booleans as strings" do
      stub_request(:get, "#{base_url}/html")
        .with(query: hash_including(
          api_key: api_key,
          url: target_url,
          js: "true",
          js_timeout: "5000",
          proxy: "residential",
          country: "gb",
          error_on_redirect: "false",
          return_script_result: "true"
        ))
        .to_return(status: 200, body: "<html>ok</html>", headers: { "content-type" => "text/html" })

      client.html(target_url, js: true, js_timeout: 5000, proxy: "residential",
                              country: "gb", error_on_redirect: false, return_script_result: true)
    end

    it "encodes headers as deepObject query params" do
      stub_request(:get, %r{#{base_url}/html})
        .to_return(status: 200, body: "x", headers: { "content-type" => "text/html" })

      client.html(target_url, headers: { "Cookie" => "session=abc", "X-Foo" => "bar" })

      expect(WebMock).to(have_requested(:get, %r{#{base_url}/html}).with do |req|
        q = req.uri.query
        q.include?("headers%5BCookie%5D=session=abc") && q.include?("headers%5BX-Foo%5D=bar")
      end)
    end

    it "drops nil options from the query string" do
      stub_request(:get, %r{#{base_url}/html})
        .to_return(status: 200, body: "x", headers: { "content-type" => "text/html" })

      client.html(target_url, custom_proxy: nil, wait_for: nil)

      expect(WebMock).to(have_requested(:get, %r{#{base_url}/html}).with do |req|
        !req.uri.query.include?("custom_proxy") && !req.uri.query.include?("wait_for")
      end)
    end

    it "returns a Hash when the server replies with JSON" do
      stub_request(:get, %r{#{base_url}/html})
        .to_return(status: 200, body: '{"answer":"hi"}', headers: { "content-type" => "application/json" })

      expect(client.html(target_url, format: "json")).to eq("answer" => "hi")
    end
  end

  describe "#text" do
    it "GETs /text with text_format and return_links" do
      stub_request(:get, "#{base_url}/text")
        .with(query: hash_including(api_key: api_key, url: target_url, text_format: "json", return_links: "true"))
        .to_return(status: 200, body: '{"title":"t","content":"c"}',
                   headers: { "content-type" => "application/json" })

      expect(client.text(target_url, text_format: "json", return_links: true))
        .to eq("title" => "t", "content" => "c")
    end

    it "returns a String when text_format is plain" do
      stub_request(:get, %r{#{base_url}/text})
        .to_return(status: 200, body: "some content", headers: { "content-type" => "text/html" })

      expect(client.text(target_url)).to eq("some content")
    end
  end

  describe "#selected" do
    it "GETs /selected with selector" do
      stub_request(:get, "#{base_url}/selected")
        .with(query: { api_key: api_key, url: target_url, selector: "h1" })
        .to_return(status: 200, body: "<h1>hi</h1>", headers: { "content-type" => "text/html" })

      expect(client.selected(target_url, selector: "h1")).to eq("<h1>hi</h1>")
    end
  end

  describe "#selected_multiple" do
    # NOTE: WebMock's request signature parses the URI into a Hash, so duplicate
    # query keys collapse. The wire format (selectors=h1&selectors=.price, no brackets)
    # is verified separately in query_encoder_spec.rb.
    it "GETs /selected-multiple and parses the JSON array response" do
      stub_request(:get, %r{#{base_url}/selected-multiple})
        .to_return(status: 200, body: '["<h1>hi</h1>","$9.99"]',
                   headers: { "content-type" => "application/json" })

      result = client.selected_multiple(target_url, selectors: ["h1", ".price"])
      expect(result).to eq(["<h1>hi</h1>", "$9.99"])

      expect(WebMock).to(have_requested(:get, %r{#{base_url}/selected-multiple})
        .with { |req| !req.uri.query.include?("selectors%5B%5D") })
    end

    it "accepts a single selector as a string and wraps it in an array" do
      stub_request(:get, %r{#{base_url}/selected-multiple})
        .to_return(status: 200, body: '["<h1>hi</h1>"]',
                   headers: { "content-type" => "application/json" })

      client.selected_multiple(target_url, selectors: "h1")

      expect(WebMock).to(have_requested(:get, %r{#{base_url}/selected-multiple})
        .with { |req| req.uri.query.include?("selectors=h1") })
    end
  end

  describe "#question" do
    it "GETs /ai/question and returns the answer string" do
      stub_request(:get, "#{base_url}/ai/question")
        .with(query: hash_including(api_key: api_key, url: target_url, question: "What is the price?"))
        .to_return(status: 200, body: "$9.99", headers: { "content-type" => "text/html" })

      expect(client.question(target_url, question: "What is the price?")).to eq("$9.99")
    end
  end

  describe "#fields" do
    it "GETs /ai/fields encoding fields as deepObject and returns the parsed JSON hash" do
      stub_request(:get, %r{#{base_url}/ai/fields})
        .to_return(status: 200, body: '{"title":"Foo","price":"$9.99"}',
                   headers: { "content-type" => "application/json" })

      result = client.fields(target_url, fields: { title: "Main product title", price: "Current price" })
      expect(result).to eq("title" => "Foo", "price" => "$9.99")

      expect(WebMock).to(have_requested(:get, %r{#{base_url}/ai/fields}).with do |req|
        q = req.uri.query
        q.include?("fields%5Btitle%5D=Main%20product%20title") &&
          q.include?("fields%5Bprice%5D=Current%20price")
      end)
    end
  end

  describe "error handling" do
    {
      400 => WebScrapingAI::BadRequestError,
      402 => WebScrapingAI::PaymentRequiredError,
      403 => WebScrapingAI::AuthenticationError,
      429 => WebScrapingAI::RateLimitError,
      500 => WebScrapingAI::ServerError,
      504 => WebScrapingAI::GatewayTimeoutError
    }.each do |status, klass|
      it "raises #{klass} on HTTP #{status}" do
        stub_request(:get, %r{#{base_url}/html})
          .to_return(status: status, body: '{"message":"boom"}',
                     headers: { "content-type" => "application/json" })

        expect { client.html(target_url) }.to raise_error(klass) do |error|
          expect(error.status).to eq(status)
          expect(error.message).to eq("boom")
        end
      end
    end

    it "exposes status_code and status_message from a 500 target-page error" do
      body = { message: "Unexpected HTTP code on the target page", status_code: 503,
               status_message: "Service Unavailable" }
      stub_request(:get, %r{#{base_url}/html})
        .to_return(status: 500, body: body.to_json, headers: { "content-type" => "application/json" })

      expect { client.html(target_url) }.to raise_error(WebScrapingAI::ServerError) do |error|
        expect(error.status_code).to eq(503)
        expect(error.status_message).to eq("Service Unavailable")
      end
    end

    it "raises a generic ApiError for unmapped status codes" do
      stub_request(:get, %r{#{base_url}/html})
        .to_return(status: 418, body: "", headers: {})

      expect { client.html(target_url) }.to raise_error(WebScrapingAI::ApiError) do |error|
        expect(error.status).to eq(418)
      end
    end

    it "tolerates a non-JSON error body" do
      stub_request(:get, %r{#{base_url}/html})
        .to_return(status: 500, body: "<html>500</html>", headers: { "content-type" => "text/html" })

      expect { client.html(target_url) }.to raise_error(WebScrapingAI::ServerError) do |error|
        expect(error.message).to eq("HTTP 500")
        expect(error.response_body).to eq("<html>500</html>")
      end
    end

    it "wraps Faraday::TimeoutError as WebScrapingAI::TimeoutError" do
      stub_request(:get, %r{#{base_url}/html}).to_raise(Faraday::TimeoutError.new("execution expired"))
      expect { client.html(target_url) }.to raise_error(WebScrapingAI::TimeoutError)
    end

    it "wraps Faraday::ConnectionFailed as WebScrapingAI::ConnectionError" do
      stub_request(:get, %r{#{base_url}/html}).to_raise(Faraday::ConnectionFailed.new("no route"))
      expect { client.html(target_url) }.to raise_error(WebScrapingAI::ConnectionError)
    end
  end

  describe "request headers" do
    it "sends a versioned User-Agent" do
      stub_request(:get, %r{#{base_url}/account})
        .to_return(status: 200, body: "{}", headers: { "content-type" => "application/json" })

      client.account

      expect(WebMock).to have_requested(:get, %r{#{base_url}/account})
        .with(headers: { "User-Agent" => "webscraping_ai-ruby/#{WebScrapingAI::VERSION}" })
    end
  end
end
