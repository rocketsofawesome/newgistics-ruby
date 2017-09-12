require 'spec_helper'

RSpec.describe Newgistics::Return do
  include IntegrationHelpers

  describe '.where' do
    vcr_options = { cassette_name: 'return/where/success' }
    context "when the API doesn't return any errors", vcr: vcr_options do
      it 'returns a list of returns' do
        use_valid_api_key
        start_date = Date.new(2017, 8, 1).iso8601
        end_date = Date.new(2017, 9, 30).iso8601

        returns = Newgistics::Return.
          where(start_timestamp: start_date, end_timestamp: end_date).
          all

        expect(returns.size).to eq(1)
        newgistics_return = returns.first
        expect(newgistics_return).to have_attributes(
          warehouse_id: "60",
          shipment_id: "91955463",
          order_id: "8aa081cb1fa5de9e011fb47803835ec9",
          status: "RETURNED",
          name: "MATT MURDOCK",
          address1: "75 Spring St",
          address2: "4th floor",
          city: "New York",
          state: "NY",
          postal_code: "10012",
          country: "US",
          email: "matt@murdock.com",
          phone: "617 123 4567",
          carrier: "USPS",
          postage_due: 0.0,
          rma_present: true,
          rma_number: "100001",
          reason: "Consumer Return",
          condition: "Opened with components opened",
          is_archived: false,
          timestamp: Time.iso8601("2017-09-05T10:30:00.0")
        )
        expect(newgistics_return.items.first).to have_attributes(
          id: "79451",
          sku: "1007-201-G",
          qty_returned: 1,
          return_reason: "Too Big",
          qty_returned_to_stock: 1
        )
      end
    end

    vcr_options = { cassette_name: 'return/where/failure' }
    context "when API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        use_invalid_api_key
        start_date = Date.new(2017, 8, 1).iso8601
        end_date = Date.new(2017, 8, 22).iso8601

        query = Newgistics::Return.
          where(start_timestamp: start_date).
          where(end_timestamp: end_date)

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end
end
