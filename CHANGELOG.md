# Changelog

All notable changes to this project will be documented in this file. This project follows [Semantic Versioning](https://semver.org/).

## Unreleased
### Changed

- Docs: `#data`'s `country:` has no fixed `us` default. Without it, Indeed country sites (e.g. `uk.indeed.com`) use that site's country and everything else uses `us`; some dedicated parsers ignore it.
- Docs: the page `timeout` maximum is 25000 ms (larger values are capped), not 30000.
- Docs: `proxy` also accepts `auto` (tries datacenter, then residential, then stealth in one request; not with `custom_proxy`). `Client::PROXY_TYPES` now includes `auto`.
- Docs: the `/data` example shows the live output (`type` `"book"`, `currency` `"£"`), and the `/data` error notes cover the retryable 500 `timeout` and `ai_unavailable` (not charged).
- Docs: the install snippet pins `~> 4.3`, since the README documents 4.3 features.
- `bin/smoke.rb`: the `/data` any-site check also accepts a 500 `ai_unavailable`.
- CHANGELOG: the 4.0.0 heading carries its release date.

## 4.3.0 — 2026-10-24
### Added

- `Client#serp` gains `pages:`, `location:`, `uule:`, `lat:`, `lon:` and `radius:`. Every search runs from one fixed location (`location`, `lat` + `lon`, or `uule`, otherwise the capital of the `gl` country), so repeats and later pages are consistent; `gl` defaults to the location's country. `pages` (1–5) fetches consecutive pages as one de-duplicated list, billed per results page returned (see https://webscraping.ai/docs#serp). Raises `ArgumentError` when `pages` or `radius` is not an Integer >= 1, or when `lat`/`lon` is not a finite number. `lat`/`lon` are sent as plain decimals rounded to 7 places (never exponent notation). Ranges and conflicting location options are left to the server's 400 (not charged). New response keys are documented in the README (`search_parameters.location_used`, `organic_results[].page`, `pagination.pages_returned`, ...).
- `Client#serp_locations(q = nil, limit: nil)` for the new `GET /serp/locations` endpoint — returns an Array of matching locations (`id`, `canonical_name`, `country_code`, `target_type`, `reach`, `gps`, ...), most populous first; pass `canonical_name` or `id` as `serp`'s `location:`. Free, and the endpoint needs no API key. Raises `ArgumentError` when `limit` is not an Integer >= 1.
- `bin/smoke.rb` checks a two-page SERP from Austin and `serp_locations("austin", limit: 3)`.

### Changed

- Docs: stop stating credit prices (they're set server-side and change); link to https://webscraping.ai/docs pricing instead.

## 4.2.0 — 2026-09-25
### Added

- `Client#data(url, country: nil, transcript: nil, transcript_language: nil, **params)` for the `GET /data` endpoint — structured JSON for a page on a supported site (e.g. YouTube, TikTok, X, LinkedIn, Instagram, Reddit) as a Hash with `request_parameters`, `parse_status` and `data`. Priced per site (see https://webscraping.ai/docs#data). The client does not check the URL's site: new sites are added server-side, and an unsupported URL or page type returns a 400 that is not charged (`BadRequestError`); its message lists what is supported. Raises `ArgumentError` when `url` is blank or not a String. Extra keyword arguments are sent as-is as query params (String, Integer, Float or boolean; Floats are sent as plain decimals). `api_key`, `url`, `country`, `transcript` and `transcript_language` as extra params raise `ArgumentError` (use the named options).
- `bin/smoke.rb` checks `/data` on a YouTube video and that `https://example.com/` gets the server's 400 "Unsupported URL" error.

### Fixed

- `TimeoutError` and `ConnectionError` redact `api_key=...` from the transport error's message and no longer carry the Faraday exception as `cause`, since it may include the request URL.

## 4.1.0 — 2026-09-25

### Added

- `Client#serp(q:, engine: nil, gl: nil, hl: nil, page: nil)` for the new `GET /serp` endpoint — parsed Google search results (organic results, related searches, pagination) as a Hash. Priced per search (see https://webscraping.ai/docs#serp). Raises `ArgumentError` when `q` is blank or not a String, or when `page` is not an Integer >= 1 (the server also rejects it with a 400, not billed; checking client-side saves the round trip). Pages are 1–100: the server rejects a `page` above 100 with a 400.
- `bin/smoke.rb` live smoke script: asserts result shapes (not just the absence of exceptions), runs page tools with `js: false` on datacenter proxies to keep the sweep cheap, and redacts the API key from failure output.

### Fixed

- `Client#inspect` and `Configuration#inspect` no longer print the API key; it is shown as `api_key="[FILTERED]"`.

## 4.0.1 — 2026-07-17

### Changed

- Documentation: expanded README — API docs, signup/dashboard links, badges, and links to the other official clients.

## 4.0.0 — 2026-05-12

### Changed

- **Complete rewrite**: the gem is now a hand-written, idiomatic Ruby client rather than OpenAPI-generated code.
- New unified entry point: `WebScrapingAI::Client.new(api_key: ...)` with one method per endpoint (`#html`, `#text`, `#selected`, `#selected_multiple`, `#question`, `#fields`, `#account`).
- Switched HTTP layer from `typhoeus` to `faraday ~> 2.0`.
- Minimum Ruby version is now `3.1`.

### Removed

- `WebScrapingAI::HTMLApi`, `WebScrapingAI::TextApi`, `WebScrapingAI::SelectedHTMLApi`, `WebScrapingAI::AIApi`, `WebScrapingAI::AccountApi` classes and all generated model classes. This is a hard break — see the README for the new API surface.
- `typhoeus` runtime dependency.

### Added

- Typed error hierarchy: `BadRequestError`, `PaymentRequiredError`, `AuthenticationError`, `RateLimitError`, `ServerError`, `GatewayTimeoutError` (all `< WebScrapingAI::ApiError`), plus `TimeoutError` and `ConnectionError` for transport failures.
- Module-level configuration: `WebScrapingAI.configure { |c| c.api_key = "..." }`.
- `WEBSCRAPING_AI_API_KEY` environment variable picked up by default.
- RSpec test suite with WebMock-based stubs.
- GitHub Actions workflows for CI and RubyGems trusted publishing on release.
