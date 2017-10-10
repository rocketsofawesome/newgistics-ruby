require "spec_helper"

RSpec.describe Newgistics do
  it "has a version number" do
    expect(Newgistics::VERSION).not_to be_nil
  end

  it "has an API object" do
    expect(Newgistics.api).not_to be_nil
  end

  it "has a configuration object" do
    expect(Newgistics.configuration).not_to be_nil
  end

  describe '.logger=' do
    it "allows developers to override the logger" do
      logger = Logger.new(File::NULL)

      Newgistics.logger = logger

      expect(Newgistics.logger).to eq(logger)
    end
  end

  describe '.configure' do
    it "sets configuration options for Newgistics" do
      Newgistics.configure do |config|
        config.api_key = 'MY_API_KEY'
      end

      expect(Newgistics.configuration.api_key).to eq('MY_API_KEY')
    end
  end
end
