require 'spec_helper'

RSpec.describe Newgistics::Inventory do
  describe '.where' do
    vcr_options = { cassette_name: 'inventory/where/success' }
    context "when the API doesn't return an error", vcr: vcr_options do
      it "returns an array of inventories" do
        start_date = Date.new(2017, 8, 1).iso8601
        query = described_class.where(sku: 'SKU')

        inventories = query.all

        expect(inventories.first).to have_attributes(
          sku: 'SKU',
          shipment_id: 'SHIPMENT_ID',
          notes: 'Damaged by forklift',
          quantity: -1,
          timestamp: DateTime.new(2015,2,19,11,0)
        )
      end
    end

    vcr_options = { cassette_name: 'inventory/where/failure' }
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
