require 'spec_helper'

RSpec.describe Newgistics::Timestamp do
  describe '#coerce' do
    context "when input is a String" do
      context "and no custom parser has been specified" do
        it "coerces the value using the ISO8601 parser" do
          timestamp = build_timestamp

          result = timestamp.coerce("2017-09-12T12:30:10-04:00")

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

      context "and a custom parser has been specified" do
        it "coerces the value using the custom parser" do
          parser = Newgistics::TimeParsers.american_datetime
          timestamp = build_timestamp(parser: parser)

          result = timestamp.coerce("08/31/2018 8:30 AM")

          newgistics_time = result.getlocal(Newgistics.time_zone.utc_offset)
          expect(newgistics_time).to have_attributes(
            year: 2018,
            month: 8,
            day: 31,
            hour: 8,
            min: 30
          )
        end
      end
    end

    context "when input is any other Object" do
      it "doesn't try to coerce the input" do
        timestamp = build_timestamp

        result = timestamp.coerce(nil)

        expect(result).to eq(nil)
      end
    end
  end

  def build_timestamp(options = {})
    Virtus::Attribute::Builder.call(described_class, options)
  end
end
