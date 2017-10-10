require 'spec_helper'

RSpec.describe Newgistics::DefaultLogger do
  describe '.build' do
    it "returns a new Logger with the right log level" do
      logger = described_class.build

      expect(logger).to be_info
    end
  end
end
