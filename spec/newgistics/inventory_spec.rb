require 'spec_helper'

RSpec.describe Newgistics::Inventory do
  include IntegrationHelpers

  describe '.where' do
    vcr_options = { cassette_name: 'inventory/where/success' }
    context "when the API doesn't return an error", vcr: vcr_options do
      it "returns an array of inventories" do
        use_valid_api_key
        start_date = Date.new(2017, 8, 1).iso8601
        query = described_class.where(sku: 'SKU')

        inventories = query.all

        expect(inventories.first).to have_attributes(
          sku: 'SKU',
          shipment_id: 'SHIPMENT_ID',
          notes: 'Damaged by forklift',
          quantity: -1,
          timestamp: newgistics_time("2015-02-19T11:00:00")
        )
      end
    end

    vcr_options = { cassette_name: 'inventory/where/failure' }
    context "when the API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        use_invalid_api_key
        start_date = Date.new(2017, 8, 1).iso8601
        query = described_class.where(start_timestamp: start_date)

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end
end
