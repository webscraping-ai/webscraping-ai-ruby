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

  describe "#serp" do
    let(:serp_body) do
      {
        search_parameters: { engine: "google", q: "coffee machines", gl: "de", hl: "de", page: 2 },
        search_information: { query_displayed: "coffee machines", organic_results_state: "Results for exact spelling" },
        organic_results: [
          { position: 1, title: "Best Coffee Machines", link: "https://www.example.com/best",
            domain: "example.com", displayed_link: "www.example.com › Reviews" }
        ],
        pagination: { current: 2, next: 3 }
      }
    end

    it "GETs /serp with q, engine, gl, hl, page and returns the parsed Hash" do
      stub_request(:get, "#{base_url}/serp")
        .with(query: { api_key: api_key, q: "coffee machines", engine: "google", gl: "de", hl: "de", page: "2" })
        .to_return(status: 200, body: serp_body.to_json, headers: { "content-type" => "application/json" })

      result = client.serp(q: "coffee machines", engine: "google", gl: "de", hl: "de", page: 2)
      expect(result["organic_results"].first["domain"]).to eq("example.com")
      expect(result["pagination"]).to eq("current" => 2, "next" => 3)
      expect(result["search_parameters"]["page"]).to eq(2)
    end

    it "sends only q when optional params are omitted" do
      stub_request(:get, "#{base_url}/serp")
        .with(query: { api_key: api_key, q: "coffee machines" })
        .to_return(status: 200, body: serp_body.to_json, headers: { "content-type" => "application/json" })

      client.serp(q: "coffee machines")
    end

    it "does not accept page-fetch options" do
      expect { client.serp(q: "coffee", js: true) }.to raise_error(ArgumentError, /js/)
    end

    it "raises ArgumentError when q is missing or blank" do
      expect { client.serp(q: "") }.to raise_error(ArgumentError, /q is required/)
      expect { client.serp(q: "  ") }.to raise_error(ArgumentError, /q is required/)
      expect { client.serp(q: nil) }.to raise_error(ArgumentError, /q is required/)
      expect { client.serp }.to raise_error(ArgumentError)
      expect(WebMock).not_to have_requested(:get, %r{#{base_url}/serp})
    end

    it "raises ArgumentError when q is only mixed whitespace" do
      expect { client.serp(q: "\t\n ") }.to raise_error(ArgumentError, /q is required/)
      expect(WebMock).not_to have_requested(:get, %r{#{base_url}/serp})
    end

    it "raises ArgumentError when q is not a String" do
      expect { client.serp(q: 123) }.to raise_error(ArgumentError, /q must be a String/)
      expect { client.serp(q: :coffee) }.to raise_error(ArgumentError, /q must be a String/)
      expect(WebMock).not_to have_requested(:get, %r{#{base_url}/serp})
    end

    it "sends q untrimmed" do
      stub_request(:get, "#{base_url}/serp")
        .with(query: { api_key: api_key, q: " coffee " })
        .to_return(status: 200, body: serp_body.to_json, headers: { "content-type" => "application/json" })

      client.serp(q: " coffee ")
    end

    [0, -1, 1.5, 2.0, "2", true, Float::NAN].each do |bad_page|
      it "raises ArgumentError for page #{bad_page.inspect}" do
        expect do
          client.serp(q: "coffee", page: bad_page)
        end.to raise_error(ArgumentError, /page must be an Integer >= 1/)
        expect(WebMock).not_to have_requested(:get, %r{#{base_url}/serp})
      end
    end

    it "accepts page 1 and large pages (the server enforces the 100 limit)" do
      stub_request(:get, %r{#{base_url}/serp})
        .to_return(status: 200, body: serp_body.to_json, headers: { "content-type" => "application/json" })

      client.serp(q: "coffee", page: 1)
      client.serp(q: "coffee", page: 150)
      expect(WebMock).to have_requested(:get, "#{base_url}/serp").with(query: hash_including(page: "150"))
    end

    it "maps error statuses to typed errors" do
      stub_request(:get, %r{#{base_url}/serp})
        .to_return(status: 402, body: '{"message":"Not enough credits"}',
                   headers: { "content-type" => "application/json" })

      expect { client.serp(q: "coffee") }.to raise_error(WebScrapingAI::PaymentRequiredError) do |error|
        expect(error.status).to eq(402)
        expect(error.message).to eq("Not enough credits")
      end
    end

    it "tolerates an error body without the scraping error envelope" do
      stub_request(:get, %r{#{base_url}/serp})
        .to_return(status: 504, body: '{"error":"upstream timeout"}',
                   headers: { "content-type" => "application/json" })

      expect { client.serp(q: "coffee") }.to raise_error(WebScrapingAI::GatewayTimeoutError) do |error|
        expect(error.message).to eq("HTTP 504")
        expect(error.response_body).to eq('{"error":"upstream timeout"}')
      end
    end
  end

  describe "#data" do
    def video_url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    def json_headers = { "content-type" => "application/json" }

    let(:data_body) do
      {
        request_parameters: { url: video_url, provider: "youtube", type: "video" },
        parse_status: "ok",
        data: { video_id: "dQw4w9WgXcQ", title: "Never Gonna Give You Up", tags: %w[rick astley] }
      }
    end

    it "GETs /data with url, country, transcript and transcript_language and returns the parsed Hash" do
      stub_request(:get, "#{base_url}/data")
        .with(query: { api_key: api_key, url: video_url, country: "de", transcript: "true",
                       transcript_language: "en" })
        .to_return(status: 200, body: data_body.to_json, headers: json_headers)

      result = client.data(video_url, country: "de", transcript: true, transcript_language: "en")
      expect(result["request_parameters"]).to eq("url" => video_url, "provider" => "youtube", "type" => "video")
      expect(result["parse_status"]).to eq("ok")
      expect(result["data"]["title"]).to eq("Never Gonna Give You Up")
    end

    it "sends only url when optional params are omitted and false transcript as \"false\"" do
      stub_request(:get, "#{base_url}/data")
        .with(query: { api_key: api_key, url: video_url })
        .to_return(status: 200, body: data_body.to_json, headers: json_headers)
      stub_request(:get, "#{base_url}/data")
        .with(query: { api_key: api_key, url: video_url, transcript: "false" })
        .to_return(status: 200, body: data_body.to_json, headers: json_headers)

      client.data(video_url)
      client.data(video_url, transcript: false)
    end

    it "sends extra params as-is, escaping & and = in keys and values" do
      stub_request(:get, "#{base_url}/data")
        .with(query: { api_key: api_key, url: video_url, "comments" => "true", "limit" => "5",
                       "a&b" => "c=d&e", "sort" => "new" })
        .to_return(status: 200, body: data_body.to_json, headers: json_headers)

      client.data(video_url, comments: true, limit: 5, "a&b" => "c=d&e", sort: "new")
      expect(WebMock).to have_requested(:get, /[?&]a%26b=c(=|%3D)d%26e&/)
    end

    it "sends a hostile unknown-site URL byte-for-byte with no client-side check" do
      odd_url = "  https://Example.COM/A%2Fb/ünï?x=1&y=a b#Frag  "
      sent = nil
      stub_request(:get, %r{#{base_url}/data})
        .with { |req| sent = req.uri.query }
        .to_return(status: 200, body: data_body.to_json, headers: json_headers)

      client.data(odd_url)
      expect(URI.decode_www_form(sent)).to eq([["api_key", api_key], ["url", odd_url]])
    end

    it "raises ArgumentError for a missing, blank or non-String url without a request" do
      expect { client.data(nil) }.to raise_error(ArgumentError, /url is required/)
      expect { client.data("") }.to raise_error(ArgumentError, /url is required/)
      expect { client.data(" \t\n") }.to raise_error(ArgumentError, /url is required/)
      expect { client.data(123) }.to raise_error(ArgumentError, /url must be a String/)
      expect(WebMock).not_to have_requested(:get, %r{#{base_url}/data})
    end

    it "requires the url argument" do
      expect { client.data }.to raise_error(ArgumentError)
    end

    it "rejects api_key and url in extra params without a request" do
      expect { client.data(video_url, api_key: "other") }.to raise_error(ArgumentError, /api_key/)
      expect { client.data(video_url, "api_key" => "other") }.to raise_error(ArgumentError, /api_key/)
      expect { client.data(video_url, "url" => "https://evil.example") }.to raise_error(ArgumentError, /url/)
      expect(WebMock).not_to have_requested(:get, %r{#{base_url}/data})
    end

    %w[country transcript transcript_language].each do |name|
      it "rejects a string-keyed #{name} extra param, set or not, without a request" do
        expect { client.data(video_url, name => "x") }.to raise_error(ArgumentError, /use the #{name}: option/)
        expect do
          client.data(video_url, name.to_sym => "y", name => "x")
        end.to raise_error(ArgumentError, /use the #{name}: option/)
        expect(WebMock).not_to have_requested(:get, %r{#{base_url}/data})
      end
    end

    [{ a: 1 }, [1, 2], :sym, 1r, Complex(1, 2), Float::NAN, Float::INFINITY, Object.new].each do |bad|
      it "rejects the extra param value #{bad.inspect} without a request" do
        expect { client.data(video_url, extra: bad) }.to raise_error(ArgumentError, /param extra must be/)
        expect(WebMock).not_to have_requested(:get, %r{#{base_url}/data})
      end
    end

    it "sends Floats as plain decimals" do
      stub_request(:get, "#{base_url}/data")
        .with(query: { api_key: api_key, url: video_url, "a" => "2.5", "b" => "100000000000000000000",
                       "c" => "0.00000015" })
        .to_return(status: 200, body: data_body.to_json, headers: json_headers)

      client.data(video_url, a: 2.5, b: 1e20, c: 1.5e-7)
    end

    it "round-trips unknown provider/type strings and data: nil with parse_failed" do
      body = { request_parameters: { url: video_url, provider: "newsite", type: "gallery" },
               parse_status: "parse_failed", data: nil }
      stub_request(:get, %r{#{base_url}/data}).to_return(status: 200, body: body.to_json, headers: json_headers)

      result = client.data(video_url)
      expect(result["request_parameters"]["provider"]).to eq("newsite")
      expect(result["request_parameters"]["type"]).to eq("gallery")
      expect(result["parse_status"]).to eq("parse_failed")
      expect(result).to have_key("data")
      expect(result["data"]).to be_nil
    end

    it "maps a 400 {message} to BadRequestError" do
      message = "Unsupported URL for /data. Supported sites: youtube, tiktok. For other sites, use /ai/fields"
      stub_request(:get, %r{#{base_url}/data})
        .to_return(status: 400, body: { message: message }.to_json, headers: json_headers)

      expect { client.data("https://example.com/") }.to raise_error(WebScrapingAI::BadRequestError) do |error|
        expect(error.status).to eq(400)
        expect(error.message).to eq(message)
      end
    end

    it "keeps the API key out of error messages and cause chains" do
      leaky = "Failed to open TCP connection for GET #{base_url}/data?api_key=#{api_key}&url=x (no route)"
      stub_request(:get, %r{#{base_url}/data}).to_raise(Faraday::ConnectionFailed.new(leaky))

      expect { client.data(video_url) }.to raise_error(WebScrapingAI::ConnectionError) do |error|
        expect(error.message).to include("api_key=[FILTERED]")
        expect(error.cause).to be_nil
        chain = []
        current = error
        while current
          chain << current.message << current.inspect
          current = current.cause
        end
        expect(chain.join("\n")).not_to include(api_key)
      end
    end
  end

  describe "#inspect" do
    it "does not reveal the API key" do
      output = client.inspect
      expect(output).not_to include(api_key)
      expect(output).to include('api_key="[FILTERED]"')
      expect(client.configuration.inspect).not_to include(api_key)
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
