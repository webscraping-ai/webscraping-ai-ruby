# -*- encoding: utf-8 -*-

=begin
#WebScraping.AI

#A client for https://webscraping.ai API. It provides Chrome JS rendering, rotating proxies and HTML parsing for web scraping.

The version of the OpenAPI document: 1.0.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 4.2.3

=end

$:.push File.expand_path("../lib", __FILE__)
require "webscraping_ai/version"

Gem::Specification.new do |s|
  s.name        = "webscraping_ai"
  s.version     = WebScrapingAI::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["WebScraping.AI"]
  s.email       = ["hello@webscraping.ai"]
  s.homepage    = "https://webscraping.ai"
  s.summary     = "WebScraping.AI Ruby Gem"
  s.description = "A client for https://webscraping.ai API. It provides Chrome JS rendering, rotating proxies and HTML parsing for web scraping."
  s.license     = 'MIT'
  s.required_ruby_version = ">= 1.9"

  s.add_runtime_dependency 'typhoeus', '~> 1.0', '>= 1.0.1'
  s.add_runtime_dependency 'json', '~> 2.1', '>= 2.1.0'

  s.add_development_dependency 'rspec', '~> 3.6', '>= 3.6.0'

  s.files         = `find *`.split("\n").uniq.sort.select { |f| !f.empty? }
  s.test_files    = `find spec/*`.split("\n")
  s.executables   = []
  s.require_paths = ["lib"]
end
