VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :faraday
  config.configure_rspec_metadata!

  config.before_record do |i|
    if i.response.headers['content-type'].include? "text/xml"
      i.response.body = Nokogiri::XML(i.response.body).to_s
    end
  end

  config.filter_sensitive_data('<API_KEY>') { ENV['NEWGISTICS_API_KEY'] }

  config.default_cassette_options = {
    record: :none
  }
end
