=begin
#WebScraping.AI

#A client for https://webscraping.ai API. It provides a web scaping automation API with Chrome JS rendering, rotating proxies and builtin HTML parsing.

The version of the OpenAPI document: 2.0.2
Contact: support@webscraping.ai
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 4.3.1

=end

require 'spec_helper'
require 'json'
require 'date'

# Unit tests for WebScrapingAI::Error
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'Error' do
  before do
    # run before each test
    @instance = WebScrapingAI::Error.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of Error' do
    it 'should create an instance of Error' do
      expect(@instance).to be_instance_of(WebScrapingAI::Error)
    end
  end
  describe 'test attribute "message"' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
