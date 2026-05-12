require "webscraping_ai"
require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.filter_run_when_matching :focus

  config.before { WebScrapingAI.reset_configuration! }
end
