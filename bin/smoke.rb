#!/usr/bin/env ruby
# Hand-run smoke test against the live API. Not part of the test suite —
# uses real credits: page calls run with js: false on the datacenter proxy to keep the cost down;
# serp_location is billed per results page returned; data_any_site is not charged when it answers
# 503, 422 or a 500 timeout/ai_unavailable; serp_locations and account are free.
# See https://webscraping.ai/docs for pricing.
#
# Usage:
#   WEBSCRAPING_AI_API_KEY=... bundle exec rake smoke
#   # or:
#   WEBSCRAPING_AI_API_KEY=... ruby bin/smoke.rb

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "json"
require "webscraping_ai"

api_key = ENV["WEBSCRAPING_AI_API_KEY"].to_s
api_key = ENV["WEBSCRAPING_AI_KEY"].to_s if api_key.empty?
if api_key.empty?
  warn "WEBSCRAPING_AI_API_KEY env var is required"
  exit 2
end

client = WebScrapingAI::Client.new(api_key: api_key)
target = "https://example.com"
# Page tools run without JS on datacenter proxies so each call costs the documented minimum.
# Default js: true would cost several times more.
page_opts = { js: false, proxy: "datacenter" }

class SmokeCheckFailed < StandardError; end

check = lambda do |condition, message|
  raise SmokeCheckFailed, message unless condition
end

non_empty_string = lambda do |result, name|
  check.call(result.is_a?(String) && !result.strip.empty?, "#{name} returned an empty result")
  result
end

redact = lambda do |text|
  text.to_s.gsub(api_key, "[REDACTED]").gsub(/api_key=[^&\s"']*/, "api_key=[REDACTED]")
end

cases = {
  "account" => -> { client.account },
  "html" => -> { non_empty_string.call(client.html(target, **page_opts), "html") },
  "text" => -> { non_empty_string.call(client.text(target, **page_opts), "text") },
  "selected" => -> { non_empty_string.call(client.selected(target, selector: "h1", **page_opts), "selected") },
  "selected_multiple" => lambda do
    result = client.selected_multiple(target, selectors: %w[h1 p], **page_opts)
    check.call(result.is_a?(Array) && result.any? { |inner| inner.is_a?(Array) && !inner.empty? },
               "selected_multiple returned no matches: #{JSON.generate(result)}")
    result
  end,
  "question" => lambda do
    non_empty_string.call(
      client.question(target, question: "What is this page about? Answer in one sentence.", **page_opts),
      "question"
    )
  end,
  "fields" => lambda do
    result = client.fields(target, fields: { title: "Page title", description: "Short description" }, **page_opts)
    check.call(result.is_a?(Hash) && result.key?("result"), "fields response has no result key")
    result
  end,
  "serp" => lambda do
    result = client.serp(q: "coffee machines")
    organic = result.is_a?(Hash) ? result["organic_results"] : nil
    check.call(organic.is_a?(Array) && !organic.empty?, "serp returned no organic_results")
    actual_q = result.dig("search_parameters", "q")
    check.call(actual_q == "coffee machines", "serp search_parameters.q was #{actual_q.inspect}")
    first = organic.first
    "#{organic.size} organic results, first: #{first.is_a?(Hash) ? first["title"].inspect : "none"}"
  end,
  "serp_location" => lambda do
    result = client.serp(q: "coffee machines", location: "Austin, TX", pages: 2)
    organic = result.is_a?(Hash) ? result["organic_results"] : nil
    check.call(organic.is_a?(Array) && !organic.empty?, "serp_location returned no organic_results")
    used = result.dig("search_parameters", "location_used")
    check.call(used.is_a?(String) && used.include?("Austin"), "serp_location location_used was #{used.inspect}")
    pages_returned = result.dig("pagination", "pages_returned")
    "#{organic.size} organic results from #{used.inspect}, pages_returned: #{pages_returned.inspect}"
  end,
  "serp_locations" => lambda do
    result = client.serp_locations("austin", limit: 3)
    check.call(result.is_a?(Array) && !result.empty?, "serp_locations returned #{JSON.generate(result)}")
    name = result.first.is_a?(Hash) ? result.first["canonical_name"] : nil
    check.call(name.is_a?(String) && name.include?("Austin"), "serp_locations first canonical_name was #{name.inspect}")
    "#{result.size} locations, first: #{name.inspect}"
  end,
  "data" => lambda do
    result = client.data("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    check.call(result.is_a?(Hash), "data returned #{result.class}")
    check.call(result["parse_status"] == "ok", "data parse_status was #{result["parse_status"].inspect}")
    provider = result.dig("request_parameters", "provider")
    check.call(provider == "youtube", "data request_parameters.provider was #{provider.inspect}")
    payload = result["data"]
    title = payload.is_a?(Hash) ? payload["title"] : nil
    check.call(title.is_a?(String) && !title.strip.empty?, "data returned no data.title")
    "#{provider}/#{result.dig("request_parameters", "type")} #{result["parse_status"]}, title: #{title.inspect}"
  end,
  # Any public page: example.com must come back as a success envelope, a free 503 when learning its
  # structure outlasts the request, a free 422 when it has no structured data, a free 500 timeout
  # when extracting the data or loading the page runs out of time, or a free 500 ai_unavailable when
  # the AI model is busy (all raised as ApiError).
  "data_any_site" => lambda do
    result = client.data("https://example.com/")
    check.call(result.is_a?(Hash) && result.key?("request_parameters"),
               "data_any_site returned no envelope: #{result.inspect}")
    "success envelope: parse_status=#{result["parse_status"].inspect}"
  rescue WebScrapingAI::ApiError => e
    expected = {
      503 => %w[structure_processing],
      422 => %w[structure_unavailable],
      500 => %w[timeout ai_unavailable]
    }[e.status]
    raise unless expected

    error_code = begin
      JSON.parse(e.response_body.to_s)["error_code"]
    rescue JSON::ParserError, TypeError
      nil
    end
    check.call(expected.include?(error_code), "data_any_site #{e.status} error_code was #{error_code.inspect}")
    "#{e.status} #{error_code}"
  end
}

failures = 0
cases.each do |name, call|
  result = call.call
  preview = result.is_a?(String) ? result : JSON.generate(result)
  puts format("  ok   %<name>-18s  %<preview>s", name: name, preview: preview[0, 120].gsub(/\s+/, " "))
rescue StandardError => e
  failures += 1
  status = e.respond_to?(:status) ? " (#{e.status})" : ""
  puts format("  FAIL %<name>-18s  %<error>s%<status>s: %<message>s",
              name: name, error: e.class.name, status: status, message: redact.call(e.message))
end

exit(failures.zero? ? 0 : 1)
