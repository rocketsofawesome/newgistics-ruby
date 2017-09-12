require "dotenv"
require "bundler/setup"
require "simplecov"
require "newgistics"
require "pry"
require "vcr"
require "timecop"

Dotenv.load
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each do |f|
  require f
end

RSpec.configure do |config|
  config.include TimeHelpers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
