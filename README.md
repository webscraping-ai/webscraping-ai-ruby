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
gem "webscraping_ai", "~> 4.3"
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

# Two pages of results searched from Austin, as one de-duplicated list
results = client.serp(q: "coffee machines", location: "Austin, TX", pages: 2)

# Location names for serp's location: (free)
client.serp_locations("austin").first["canonical_name"] # => "Austin,Texas,United States"

# Structured data for any public web page
page = client.data("https://books.toscrape.com/catalogue/a-light-in-the-attic_1000/index.html")
page["data"]["title"]

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
| `timeout` | `Integer` | `10000` | Page retrieval timeout in ms (1–25000; larger values are capped at 25000) |
| `js` | `Boolean` | `true` | Execute on-page JavaScript via headless Chromium |
| `js_timeout` | `Integer` | `2000` | JS rendering timeout in ms (1–20000) |
| `wait_for` | `String` | — | CSS selector to wait for before returning (overrides `js_timeout`) |
| `proxy` | `String` | `"datacenter"` | One of `datacenter`, `residential`, `stealth`, `auto`. `auto` tries datacenter, then residential, then stealth in one request and bills only the tier that worked; it can't be combined with `custom_proxy` |
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
It returns the parsed search results as a `Hash`. Billed per results page returned (see [pricing](https://webscraping.ai/docs#serp)); failed searches are not charged.

Every search runs from one fixed location: `location`, `lat` + `lon`, or `uule`, otherwise the capital of
the `gl` country (for the few countries outside the location list, Google places the search by the exit IP),
so repeats and later pages are consistent. `gl` defaults to the location's country.
`pages` (1–5) fetches consecutive pages, starting at `page`, as one de-duplicated list, billed per page returned.

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `q` | `String` | — | Search query (required; blank or non-String raises `ArgumentError`) |
| `engine` | `String` | `"google"` | Search engine; currently only `google` |
| `gl` | `String` | `"us"` | Two-letter country code for the search. Defaults to the country of `location`, `lat`/`lon` or `uule`, otherwise `us` |
| `hl` | `String` | `"en"` | Two-letter language code for the results |
| `page` | `Integer` | `1` | Results page number (10 results per page). Must be an `Integer` >= 1, otherwise `ArgumentError`; the server rejects values above 100 with a 400 (not billed) |
| `pages` | `Integer` | `1` | Number of consecutive results pages to fetch in one call, starting at `page`, from 1 to 5. Duplicates across pages are removed, `position` counts through the combined list and each result gets a `page` key. Must be an `Integer` >= 1, otherwise `ArgumentError` |
| `location` | `String` | — | Where the search runs from: a name such as `"Austin,Texas,United States"` or `"Austin, TX"`, or an `id` from `#serp_locations`. Large cities also match local names, e.g. `"Москва"`. Sent as-is; an unknown name returns a 400 (not billed). Cannot be combined with `uule`, `lat` or `lon` |
| `uule` | `String` | — | Google-encoded location (`w+CAIQICI…` or `a+…`). Cannot be combined with `location`, `lat` or `lon` |
| `lat` | `Float` | — | Latitude of the search origin in decimal degrees (-90 to 90). Requires `lon`. Must be a finite number, otherwise `ArgumentError`; sent as a plain decimal rounded to 7 places |
| `lon` | `Float` | — | Longitude of the search origin in decimal degrees (-180 to 180). Requires `lat`. Same rules as `lat` |
| `radius` | `Integer` | — | Radius in meters around `location` or `lat`/`lon`, from 1 to 1000. Must be an `Integer` >= 1, otherwise `ArgumentError` |

Ranges and which location options can be combined are checked by the server (a 400, not billed).

```ruby
results = client.serp(q: "coffee machines", gl: "gb", page: 2)
results["search_information"]["organic_results_state"] # => "Results for exact spelling"
results["organic_results"].each do |r|
  puts "#{r["position"]}. #{r["title"]} — #{r["link"]}"
end
results["pagination"] # => { "current" => 2, "next" => 3 }

results = client.serp(q: "coffee machines", location: "Austin, TX", pages: 2)
results["search_parameters"]["location_used"] # => "Austin,Texas,United States"
results["organic_results"].last["page"]       # => 2 (position counts through both pages)
results["pagination"]["pages_returned"] # => 2
```

Response keys: `search_parameters` (`engine`, `q`, `gl`, `hl`, `page`; `location_used`, `lat` and `lon`, usually
present, which are the `gl` country's capital when no location is given; `location_requested` and `radius` when given;
`pages` only above 1), `search_information`
(`query_displayed`, `organic_results_state`, optional `showing_results_for` and `total_results`),
`organic_results` (`position` — 1-based within the page, or through the combined list with `pages` above 1 —
`title`, `link`, `domain`, `displayed_link`, optional `snippet` and `date`, and `page` with `pages` above 1),
optional `related_searches` (`query`), and `pagination` (`current`, optional `next`, and `pages_returned` with
`pages` above 1). Optional keys are absent when Google does not show them.

### SERP locations (`#serp_locations`)

`#serp_locations(q = nil, limit: nil)` looks up names for `#serp`'s `location:` option. It is free and the
endpoint needs no API key (the client still sends yours). It returns an `Array` of up to 10 location `Hash`es,
most populous first. `q` is part of an English location name (without it, the most populous locations are
returned); `limit` must be an `Integer` >= 1 (the server allows up to 10).

```ruby
locations = client.serp_locations("austin", limit: 3)
locations.first
# => { "id" => "1026201", "google_id" => 1026201, "google_parent_id" => 21176, "name" => "Austin",
#      "canonical_name" => "Austin,Texas,United States", "country_code" => "US", "target_type" => "City",
#      "reach" => 974447, "gps" => [-97.7431, 30.2672] }

client.serp(q: "coffee machines", location: locations.first["canonical_name"]) # or its "id"
```

`gps` is `[longitude, latitude]`, `target_type` is an open set of strings (e.g. `City`, `State`, `Country`),
and `google_parent_id` is `nil` for countries.

### Structured data (`#data`)

`#data(url, country: nil, transcript: nil, transcript_language: nil, **params)` returns structured JSON
for any public web page as a `Hash`. Pass the page's normal URL; the site the page belongs to (`provider`,
e.g. `toscrape.com`) and the kind of page (`type`, e.g. `book`) are detected from it. See
[pricing](https://webscraping.ai/docs#data).

Some popular sites have dedicated parsers with fixed fields. For other sites, the first request for a new
kind of page also has an AI model learn the page's structure, so it can take up to about 45 seconds (keep
the client `timeout`, 60 seconds by default, above that); afterwards pages of that kind on that site
return data straight away for every user. The client never checks the
URL's site, so new sites and parsers work without a gem upgrade.

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `url` | `String` | — | Page URL (required, positional; blank or non-String raises `ArgumentError`) |
| `country` | `String` | — | Two-letter country code of the proxy used to fetch the page. Without it, Indeed country sites (e.g. `uk.indeed.com`) use that site's country and everything else uses `us`. Some dedicated parsers use a fixed route and ignore it |
| `transcript` | `Boolean` | `false` | Video pages on sites with a dedicated parser only. Also fetch the video's transcript into `data.transcript`. It's null when no matching captions are available. If the transcript fetch itself fails, the whole request fails with a 500 and is not charged |
| `transcript_language` | `String` | — | With `transcript: true`. Caption language to pick, e.g. `en` or `de`. Without it, English is preferred, then the first available track. If the video has no captions in that language, `data.transcript` is null |
| `**params` | `String`, `Integer`, `Float`, boolean | — | Extra query params sent as-is, for provider-specific params added later (`nil` omits one). `api_key`, `url`, `country`, `transcript` and `transcript_language` raise `ArgumentError`; use the named options for the last three |

```ruby
result = client.data("https://books.toscrape.com/catalogue/a-light-in-the-attic_1000/index.html")
result["request_parameters"] # => { "url" => "...", "provider" => "toscrape.com", "type" => "book" }
result["parse_status"]       # => "ok" (or "parse_failed" / "not_found")
result["data"]               # => { "title" => "A Light in the Attic", "price" => 51.77, "currency" => "£" }
                             #    shape depends on provider and type; may be nil
```

**503 — structure still being learned.** When learning the page's structure takes longer than the
request, or another request is already learning that site, the API returns a 503 with `error_code` `"structure_processing"` and `retry_after` (seconds),
plus a `Retry-After` header; not charged. It is raised as a plain `WebScrapingAI::ApiError` with `status`
503; the body is in `JSON.parse(e.response_body)`. Retry after `retry_after` seconds; the retry usually
returns data (if learning failed meanwhile, it may learn again or return the 422 below):

```ruby
url = "https://books.toscrape.com/catalogue/a-light-in-the-attic_1000/index.html"
begin
  result = client.data(url)
rescue WebScrapingAI::ApiError => e
  raise unless e.status == 503

  # { "message" => "...", "error_code" => "structure_processing", "retry_after" => 30 }
  sleep JSON.parse(e.response_body)["retry_after"] || 30
  result = client.data(url)
end
```

**422 — no structured data.** If no structured data can be found on the page (empty page, login wall),
the API returns a 422 with `error_code` `"structure_unavailable"`, not charged. It is raised as a plain
`WebScrapingAI::ApiError` with `status` 422; the `error_code` is in `JSON.parse(e.response_body)`. Use
`#fields` for such pages instead.

**Other `/data` errors.** Redirects within the same site (http→https, `www`, trailing slash) are followed;
a redirect to another site raises `WebScrapingAI::ServerError` (500, `error_code` `"target_redirect"`, the
target in the message), not charged. Starting too many new kinds of pages in an hour raises
`WebScrapingAI::RateLimitError` (429, `error_code` `"rate_limited"`). If loading the page or extracting the
data runs out of time, or the AI model is busy, it raises `WebScrapingAI::ServerError` (500, `error_code`
`"timeout"` or `"ai_unavailable"`), not charged; call again.

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
rescue WebScrapingAI::ApiError => e
  # Any other status, e.g. 503 or 422 from #data (structure still being learned / no structured data).
end
```

## Development

```bash
bin/setup        # bundle install
bundle exec rspec
bundle exec rubocop
```

## Smoke testing

`bin/smoke.rb` hits every endpoint once against the live API, loading the gem from `lib/` so it tests the working tree. It is not part of the spec suite and uses real credits (see [pricing](https://webscraping.ai/docs)): the four page calls run with `js: false` and `proxy: "datacenter"` to keep the cost down, there are two AI calls (`question`, `fields`), two SERP calls (one plain, one two-page search from Austin, billed per page returned) and one `/data` call on a page on a site with a dedicated parser. `serp_locations` is free. A second `/data` call on `https://example.com/` (any site) must come back as a success envelope, a free 503 `structure_processing`, a free 422 `structure_unavailable`, or a free 500 `timeout` or `ai_unavailable`, proving there is no client-side site filter. Each case checks the result shape as well as exceptions (e.g. SERP must return organic results for the right query, the Austin SERP must report an Austin `location_used`, `serp_locations` must find Austin, `/data` must parse a title, `selected_multiple` must match something), and failure messages redact the API key.

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
