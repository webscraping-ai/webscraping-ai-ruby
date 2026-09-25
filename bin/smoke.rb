#!/usr/bin/env ruby
# Hand-run smoke test against the live API. Not part of the test suite —
# costs ~32 credits per full sweep: 4 page calls x 1 (js: false, datacenter proxy),
# question + fields 2 x 6, serp 15, account free. The SERP call alone is 15.
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
# Page tools run without JS on datacenter proxies so each call costs the documented 1 credit
# (AI tools 6). Default js: true would cost several times more.
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
