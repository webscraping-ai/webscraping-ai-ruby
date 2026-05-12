lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "webscraping_ai/version"

Gem::Specification.new do |spec|
  spec.name          = "webscraping_ai"
  spec.version       = WebScrapingAI::VERSION
  spec.authors       = ["WebScraping.AI"]
  spec.email         = ["hello@webscraping.ai"]

  spec.summary       = "Ruby client for the WebScraping.AI API."
  spec.description   = "WebScraping.AI provides LLM-powered web scraping with Chromium JavaScript " \
                       "rendering, rotating proxies, and built-in HTML parsing. This gem is the " \
                       "official Ruby client."
  spec.homepage      = "https://webscraping.ai"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/webscraping-ai/webscraping-ai-ruby"
  spec.metadata["bug_tracker_uri"]   = "https://github.com/webscraping-ai/webscraping-ai-ruby/issues"
  spec.metadata["changelog_uri"]     = "https://github.com/webscraping-ai/webscraping-ai-ruby/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://webscraping.ai/docs/api"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir[
    "lib/**/*.rb",
    "LICENSE",
    "README.md",
    "CHANGELOG.md",
    "webscraping_ai.gemspec"
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
end
