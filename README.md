# WebScraping.AI Ruby Client

Official Ruby client for the [WebScraping.AI](https://webscraping.ai) API. Provides LLM-powered web scraping with Chromium JavaScript rendering, rotating proxies, and built-in HTML parsing.

[![Gem Version](https://badge.fury.io/rb/webscraping_ai.svg)](https://rubygems.org/gems/webscraping_ai)

## Installation

```ruby
# Gemfile
gem "webscraping_ai", "~> 4.0"
```

Or:

```bash
gem install webscraping_ai
```

Requires Ruby 3.1+.

## Quick start

```ruby
require "webscraping_ai"

client = WebScrapingAI::Client.new(api_key: ENV.fetch("WEBSCRAPING_AI_API_KEY"))

# Page HTML
html = client.html("https://example.com", js: true)

# Visible text
text = client.text("https://example.com")

# CSS-selected fragment
title = client.selected("https://example.com", selector: "h1")

# Multiple selectors at once
fragments = client.selected_multiple("https://example.com", selectors: ["h1", ".price"])

# Ask the LLM a question about the page
answer = client.question("https://example.com", question: "What is the main product?")

# Extract structured fields with the LLM
data = client.fields(
  "https://example.com",
  fields: {
    title: "Main product title",
    price: "Current product price",
    description: "Full product description"
  }
)

# Check your account quota
info = client.account
# => { "remaining_api_calls" => 200_000, "resets_at" => 1_617_073_667, "remaining_concurrency" => 100 }
```

## Configuration

Configure globally once, then create clients without arguments:

```ruby
WebScrapingAI.configure do |config|
  config.api_key      = ENV.fetch("WEBSCRAPING_AI_API_KEY")
  config.timeout      = 60   # seconds, total request timeout
  config.open_timeout = 10   # seconds, connection timeout
end

client = WebScrapingAI::Client.new
```

The gem also reads `WEBSCRAPING_AI_API_KEY` from the environment automatically.

Per-instance overrides:

```ruby
client = WebScrapingAI::Client.new(
  api_key: "...",
  timeout: 90,
  base_url: "https://api.webscraping.ai"
)
```

## Endpoints and options

All page-fetching endpoints accept these common options (passed as keyword arguments):

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `headers` | `Hash` | — | HTTP headers to send to the target page (e.g. `{ "Cookie" => "session=..." }`) |
| `timeout` | `Integer` | `10000` | Page retrieval timeout in ms (1–30000) |
| `js` | `Boolean` | `true` | Execute on-page JavaScript via headless Chromium |
| `js_timeout` | `Integer` | `2000` | JS rendering timeout in ms (1–20000) |
| `wait_for` | `String` | — | CSS selector to wait for before returning (overrides `js_timeout`) |
| `proxy` | `String` | `"datacenter"` | One of `datacenter`, `residential`, `stealth` |
| `country` | `String` | `"us"` | Proxy country: `us`, `gb`, `de`, `it`, `fr`, `ca`, `es`, `ru`, `jp`, `kr`, `in`, `hk`, `tr` |
| `custom_proxy` | `String` | — | Your own proxy in `http://user:pass@host:port` form |
| `device` | `String` | `"desktop"` | One of `desktop`, `mobile`, `tablet` |
| `error_on_404` | `Boolean` | `false` | Raise an error if the target page returns 404 |
| `error_on_redirect` | `Boolean` | `false` | Raise an error if the target page redirects |
| `js_script` | `String` | — | Custom JS to execute on the page |

Endpoint-specific options:

- `#html` — `return_script_result` (`Boolean`), `format` (`"json"`/`"text"`)
- `#text` — `text_format` (`"plain"`/`"xml"`/`"json"`), `return_links` (`Boolean`, only with `text_format: "json"`)
- `#selected` — `selector` (`String`), `format` (`"json"`/`"text"`)
- `#selected_multiple` — `selectors` (`Array<String>` or single `String`)
- `#question` — `question` (`String`, required), `format` (`"json"`/`"text"`)
- `#fields` — `fields` (`Hash<String, String>`, required) — keys are field names, values are descriptions

Returns: `String` for HTML/text responses, `Hash`/`Array` for JSON responses.

## Error handling

All API errors inherit from `WebScrapingAI::ApiError` and expose `#status`, `#message`, `#status_code`, `#status_message`, `#body`, and `#response_body`.

```ruby
begin
  client.html("https://example.com")
rescue WebScrapingAI::RateLimitError => e
  # 429 — too many concurrent requests
  sleep 1 and retry
rescue WebScrapingAI::PaymentRequiredError => e
  # 402 — out of API credits
rescue WebScrapingAI::AuthenticationError => e
  # 403 — wrong API key
rescue WebScrapingAI::BadRequestError => e
  # 400 — invalid parameters
rescue WebScrapingAI::ServerError => e
  # 500 — target page returned a non-2xx code, or unexpected error.
  # e.status_code / e.status_message expose the target page's response.
rescue WebScrapingAI::GatewayTimeoutError => e
  # 504 — page took longer than `timeout` ms to load. Try a higher `timeout:`.
rescue WebScrapingAI::TimeoutError => e
  # Client-side: the HTTP request exceeded `Client#timeout`.
rescue WebScrapingAI::ConnectionError => e
  # Network failure before a response was received.
end
```

## Development

```bash
bin/setup        # bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT — see [LICENSE](LICENSE).
