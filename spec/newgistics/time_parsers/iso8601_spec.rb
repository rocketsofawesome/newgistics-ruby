require 'spec_helper'

RSpec.describe Newgistics::TimeParsers::ISO8601 do
  describe '#parse' do
    context "when input is a String with an ISO8601 format" do
      context "and it includes a timezone" do
        it "doesn't add the newgistics timezone" do
          parser = described_class.new

          result = parser.parse("2017-09-12T12:30:10-04:00")

          expect(result.getlocal("-04:00")).to have_attributes(
            year: 2017,
            month: 9,
            day: 12,
            hour: 12,
            min: 30,
            sec: 10
          )
        end
      end

      context "and it doesn't include a timezone" do
        it "adds the newgistics timezone" do
          parser = described_class.new

          result = parser.parse("2017-09-12T12:00:00")

          expect(result.utc_offset).
            to eq(Newgistics.local_time_zone.utc_offset_in_seconds)
        end
      end

      context "and it's an invalid date" do
        it "doesn't coerce the value" do
          parser = described_class.new

          result = parser.parse("2017-20-12T12:00:00-04:00")

          expect(result).to eq("2017-20-12T12:00:00-04:00")
        end
      end
    end

    context "when input is a String with a different format than ISO8601" do
      it "doesn't coerce the input" do
        parser = described_class.new

        result = parser.parse("09/12/2017")

        expect(result).to eq("09/12/2017")
      end
    end
  end
end
