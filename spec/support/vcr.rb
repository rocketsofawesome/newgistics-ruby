VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :faraday
  config.configure_rspec_metadata!

  config.default_cassette_options = {
    record: :none
  }
end
