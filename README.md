# WebScraping.AI Ruby Client

[![Gem Version](https://badge.fury.io/rb/webscraping_ai.svg)](https://rubygems.org/gems/webscraping_ai)
[![CI](https://github.com/webscraping-ai/webscraping-ai-ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/webscraping-ai/webscraping-ai-ruby/actions/workflows/ci.yml)

Official Ruby client for the [WebScraping.AI](https://webscraping.ai) API —
web scraping with Chromium JavaScript rendering, rotating
datacenter/residential/stealth proxies, and AI-powered question answering and
structured field extraction on any page. See the
[API documentation](https://webscraping.ai/docs) for the full parameter reference.

## Installation

```ruby
# Gemfile
gem "webscraping_ai", "~> 4.1"
```

Or:

```bash
gem install webscraping_ai
```

Requires Ruby 3.1+.

## Quick start

[Sign up](https://webscraping.ai/auth/sign_up) to get an API key — a free
trial, no credit card required. Your key lives in the
[dashboard](https://webscraping.ai/dashboard).

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

# Google search results (SERP) for a query
results = client.serp(q: "coffee machines", gl: "us", hl: "en", page: 1)
results["organic_results"].first["link"]

# Structured data for a page on a supported site (YouTube, TikTok, X, LinkedIn, Instagram, Reddit, ...)
video = client.data("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
video["data"]["title"]

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

### SERP (`#serp`)

`#serp` is query-shaped rather than URL-shaped, so none of the page-fetch options above apply.
It returns the parsed search results as a `Hash`. Priced per search (see [pricing](https://webscraping.ai/docs#serp)); failed searches are not charged.

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `q` | `String` | — | Search query (required; blank or non-String raises `ArgumentError`) |
| `engine` | `String` | `"google"` | Search engine; currently only `google` |
| `gl` | `String` | `"us"` | Two-letter country code for the search |
| `hl` | `String` | `"en"` | Two-letter language code for the results |
| `page` | `Integer` | `1` | Results page number (10 results per page). Must be an `Integer` >= 1, otherwise `ArgumentError`; the server rejects values above 100 with a 400 (not billed) |

```ruby
results = client.serp(q: "coffee machines", gl: "gb", page: 2)
results["search_information"]["organic_results_state"] # => "Results for exact spelling"
results["organic_results"].each do |r|
  puts "#{r["position"]}. #{r["title"]} — #{r["link"]}"
end
results["pagination"] # => { "current" => 2, "next" => 3 }
```

Response keys: `search_parameters` (`engine`, `q`, `gl`, `hl`, `page`), `search_information`
(`query_displayed`, `organic_results_state`, optional `showing_results_for` and `total_results`),
`organic_results` (`position` — 1-based within the page — `title`, `link`, `domain`, `displayed_link`,
optional `snippet` and `date`), optional `related_searches` (`query`), and `pagination` (`current`, optional `next`).
Optional keys are absent when Google does not show them.

### Structured data (`#data`)

`#data(url, country: nil, transcript: nil, transcript_language: nil, **params)` returns structured JSON
for a public page on a supported site as a `Hash`. Pass the page's normal URL; the site (`provider`) and
page kind (`type`) are detected from it. Priced per site (see [pricing](https://webscraping.ai/docs#data)),
including pages that parse empty (`parse_status` `"parse_failed"`) or no longer exist (`"not_found"`);
unsupported URLs and failed fetches are not charged.
None of the page-fetch options above apply.

Supported sites today include, for example, YouTube (video/channel/playlist), TikTok (video/profile),
X/Twitter (tweet/profile), LinkedIn (company/job/profile), Instagram (post/reel/profile) and Reddit
(post/subreddit/user). **More sites are added server-side**, and they work with this gem without an
upgrade: the client never checks the URL's site. An unsupported URL or page type returns a 400 that is
not charged (`WebScrapingAI::BadRequestError`). Its message lists what is supported.

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `url` | `String` | — | Page URL (required, positional; blank or non-String raises `ArgumentError`) |
| `country` | `String` | `"us"` | Two-letter country code of the proxy used to fetch the page, `us` by default |
| `transcript` | `Boolean` | `false` | YouTube videos only. Also fetch the video's transcript into `data.transcript`. It's null when no matching captions are available. If the transcript fetch itself fails, the whole request fails with a 500 and is not charged |
| `transcript_language` | `String` | — | Caption language to pick, e.g. `en` or `de`. Without it, English is preferred, then the first available track. If the video has no captions in that language, `data.transcript` is null |
| `**params` | `String`, `Integer`, `Float`, boolean | — | Extra query params sent as-is, for provider-specific params added later (`nil` omits one). `api_key`, `url`, `country`, `transcript` and `transcript_language` raise `ArgumentError`; use the named options for the last three |

```ruby
result = client.data("https://www.youtube.com/watch?v=dQw4w9WgXcQ", transcript: true)
result["request_parameters"] # => { "url" => "...", "provider" => "youtube", "type" => "video" }
result["parse_status"]       # => "ok" (or "parse_failed" / "not_found")
result["data"]["title"]      # shape depends on provider and type; may be nil

begin
  client.data("https://example.com/")
rescue WebScrapingAI::BadRequestError => e
  e.message # => "Unsupported URL for /data. Supported sites: youtube, tiktok, ..."
end
```

`provider`, `type` and `parse_status` are open sets of strings, and `data` is the decoded JSON as-is
(no per-site classes), so new sites and fields show up without a gem release.

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

## Smoke testing

`bin/smoke.rb` hits every endpoint once against the live API, loading the gem from `lib/` so it tests the working tree. It is not part of the spec suite and costs ~47 credits per run: the four page calls run with `js: false` and `proxy: "datacenter"` (1 credit each), `question` and `fields` cost 6 each, and the SERP and `/data` (YouTube video) calls are 15 each. A second `/data` call on `https://example.com/` must come back as the server's free 400, proving there is no client-side site filter. Each case checks the result shape as well as exceptions (e.g. SERP must return organic results for the right query, `/data` must parse a title, `selected_multiple` must match something), and failure messages redact the API key.

```bash
WEBSCRAPING_AI_API_KEY=... bundle exec rake smoke
# or: WEBSCRAPING_AI_API_KEY=... ruby bin/smoke.rb
```

Each endpoint prints an `ok` or `FAIL` line; the script exits non-zero if any call fails.

## Links

- [WebScraping.AI](https://webscraping.ai) — features, pricing, signup
- [API documentation](https://webscraping.ai/docs)
- [Dashboard](https://webscraping.ai/dashboard) — API key, usage, request builder
- Other official clients: [Python](https://github.com/webscraping-ai/webscraping-ai-python) · [JavaScript](https://github.com/webscraping-ai/webscraping-ai-js) · [PHP](https://github.com/webscraping-ai/webscraping-ai-php) · [Go](https://github.com/webscraping-ai/webscraping-ai-go) · [Java](https://github.com/webscraping-ai/webscraping-ai-java) · [.NET](https://github.com/webscraping-ai/webscraping-ai-dotnet) · [CLI](https://github.com/webscraping-ai/webscraping-ai-cli) · [MCP server](https://github.com/webscraping-ai/webscraping-ai-mcp-server) · [n8n node](https://github.com/webscraping-ai/webscraping-ai-n8n)
- Support: [support@webscraping.ai](mailto:support@webscraping.ai)

## License

MIT — see [LICENSE](LICENSE).
