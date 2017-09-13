require 'spec_helper'

RSpec.describe Newgistics::TimeZone do
  before { Timecop.freeze(Time.parse("2017-09-12T08:00:00-04:00")) }
  after { Timecop.return }

  describe '#utc_offset' do
    it "returns the UTC offset formatted to HH:MM" do
      time_zone = described_class.new('America/New_York')

      expect(time_zone.utc_offset).to eq("-04:00")
    end
  end

  describe '#utc_offset_in_seconds' do
    it "returns the UTC offset in seconds from the Timezone" do
      time_zone = described_class.new('America/Mexico_City')

      expect(time_zone.utc_offset_in_seconds).to eq(-5 * 3600)
    end
  end
end
