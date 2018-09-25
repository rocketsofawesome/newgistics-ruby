require 'spec_helper'

RSpec.describe Newgistics::TimeParsers::AmericanDatetime do
  describe '#parse' do
    context "when the given string matches the american datetime format" do
      context "and the string contains the timezone" do
        it "returns a parsed time object" do
          parser = described_class.new

          result = parser.parse("08/31/2018 8:30 PM -04:00")

          expect(result.getlocal('-04:00')).to have_attributes(
            year: 2018,
            month: 8,
            day: 31,
            hour: 20,
            min: 30
          )
        end
      end

      context "and the string doesn't contain a timezone" do
        it "parses the date time using Newgistics' timezone" do
          parser = described_class.new

          result = parser.parse("08/31/2018 8:30 PM")

          newgistics_time = result.getlocal(Newgistics.time_zone.utc_offset)
          expect(newgistics_time).to have_attributes(
            year: 2018,
            month: 8,
            day: 31,
            hour: 20,
            min: 30
          )
        end
      end
    end

    context "when the given string doesn't match the custom format" do
      it "returns the given string" do
        parser = described_class.new

        result = parser.parse('2018-08-31T20:30')

        expect(result).to eq('2018-08-31T20:30')
      end
    end
  end
end
