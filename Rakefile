require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Run the live API smoke test (needs WEBSCRAPING_AI_API_KEY; ~47 credits)"
task :smoke do
  ruby File.expand_path("bin/smoke.rb", __dir__)
end

task default: :spec
