require 'spec_helper'

RSpec.describe Newgistics::Inventory do
  describe '.where' do
    context "when the API doesn't return an error" do
      it "returns an array of inventories"
    end

    vcr_options = { cassette_name: 'inventory/where/failure', record: :new_episodes }
    context "when the API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        start_date = Date.new(2017, 8, 1).iso8601
        Newgistics.configure { |c| c.api_key = 'INVALID' }
        query = described_class.where(start_timestamp: start_date)

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end
end
