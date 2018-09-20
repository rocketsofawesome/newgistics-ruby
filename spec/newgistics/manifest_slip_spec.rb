require 'spec_helper'

RSpec.describe Newgistics::ManifestSlip do
  describe '#estimated_arrival_date=' do
    context "when the new date is a String" do
      context "and the string matches the MM/DD/YYYY format" do
        it "parses valid dates correctly" do
          slip = described_class.new

          slip.estimated_arrival_date = '08/30/2018'

          expect(slip.estimated_arrival_date).to have_attributes(
            month: 8, day: 30, year: 2018
          )
        end

        it "falls back with invalid dates" do
          slip = described_class.new

          slip.estimated_arrival_date = '08/33/2018'

          expect(slip.estimated_arrival_date).to eq('08/33/2018')
        end
      end

      context "and the string doesn't match the MM/DD/YYYY format" do
        it "tries to parse the value as a date" do
          slip = described_class.new

          slip.estimated_arrival_date = '2018-08-30'

          expect(slip.estimated_arrival_date).to have_attributes(
            month: 8, day: 30, year: 2018
          )
        end
      end
    end

    context "when the new date isn't a string" do
      it "sets the value of estimated_arrival_date" do
        slip = described_class.new
        date = Date.new(2018,8,31)

        slip.estimated_arrival_date = date

        expect(slip.estimated_arrival_date).to eq(date)
      end
    end
  end
end
