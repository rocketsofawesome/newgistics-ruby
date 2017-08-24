require 'spec_helper'

RSpec.describe Newgistics::Return do
  describe '.where' do
    context "when returns return successfully" do
      it 'returns a list of returns'
    end

    vcr_options = { cassette_name: 'return/where/failure' }
    context "when API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        start_date = Date.new(2017, 8, 1).iso8601
        end_date = Date.new(2017, 8, 22).iso8601
        Newgistics.configure { |c| c.api_key = 'ABC123' }

        query = Newgistics::Return.
          where(start_timestamp: start_date).
          where(end_timestamp: end_date)

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end
end
