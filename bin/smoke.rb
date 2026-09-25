#!/usr/bin/env ruby
# Hand-run smoke test against the live API. Not part of the test suite —
# costs ~32 credits per full sweep (the SERP call alone is 15).
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

serp_preview = lambda do |result|
  organic = result.is_a?(Hash) ? Array(result["organic_results"]) : []
  first = organic.first
  "#{organic.size} organic results, first: #{first.is_a?(Hash) ? first["title"].inspect : "none"}"
end

cases = {
  "account" => -> { client.account },
  "html" => -> { client.html(target) },
  "text" => -> { client.text(target) },
  "selected" => -> { client.selected(target, selector: "h1") },
  "selected_multiple" => -> { client.selected_multiple(target, selectors: %w[h1 p]) },
  "question" => -> { client.question(target, question: "What is this page about? Answer in one sentence.") },
  "fields" => -> { client.fields(target, fields: { title: "Page title", description: "Short description" }) },
  "serp" => -> { serp_preview.call(client.serp(q: "coffee machines")) }
}

failures = 0
cases.each do |name, call|
  result = call.call
  preview = result.is_a?(String) ? result : JSON.generate(result)
  puts format("  ok   %<name>-18s  %<preview>s", name: name, preview: preview[0, 120].gsub(/\s+/, " "))
rescue WebScrapingAI::Error => e
  failures += 1
  status = e.respond_to?(:status) ? " (#{e.status})" : ""
  puts format("  FAIL %<name>-18s  %<error>s%<status>s: %<message>s",
              name: name, error: e.class.name, status: status, message: e.message)
end

exit(failures.zero? ? 0 : 1)
