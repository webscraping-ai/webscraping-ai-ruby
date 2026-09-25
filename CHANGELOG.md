# Changelog

All notable changes to this project will be documented in this file. This project follows [Semantic Versioning](https://semver.org/).

## 4.1.0 — 2026-09-25

### Added

- `Client#serp(q:, engine: nil, gl: nil, hl: nil, page: nil)` for the new `GET /serp` endpoint — parsed Google search results (organic results, related searches, pagination) as a Hash. Flat 15 credits per search. Raises `ArgumentError` when `q` is blank or not a String, or when `page` is not an Integer >= 1 (the server also rejects it with a 400, not billed; checking client-side saves the round trip). Pages are 1–100: the server rejects a `page` above 100 with a 400.
- `bin/smoke.rb` live smoke script: asserts result shapes (not just the absence of exceptions), runs page tools with `js: false` on datacenter proxies (~32 credits per sweep), and redacts the API key from failure output.

### Fixed

- `Client#inspect` and `Configuration#inspect` no longer print the API key; it is shown as `api_key="[FILTERED]"`.

## 4.0.1 — 2026-07-17

### Changed

- Documentation: expanded README — API docs, signup/dashboard links, badges, and links to the other official clients.

## [4.0.0] - Unreleased

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
