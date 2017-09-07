require 'spec_helper'

RSpec.describe Newgistics::Shipment do
  include IntegrationHelpers

  describe '.where' do
    vcr_options = { cassette_name: 'shipment/where/successfully' }
    context "when the shipments are queried successfully", vcr: vcr_options do
      it 'returns a list of shipment objects' do
        use_valid_api_key
        start_date = Date.new(2017, 8, 1).iso8601
        end_date = Date.new(2017, 9, 7).iso8601

        results = Newgistics::Shipment.
          where(start_received_timestamp: start_date).
          where(end_received_timestamp: end_date).
          all

        expect(results.length).to eql 2
        expect(results.last).to have_attributes(
          order_id: "R123456789",
          name: "STEPHEN STRANGE",
          first_name: "STEPHEN",
          last_name: "STRANGE",
          address1: "75 SPRING ST FL 4",
          city: "NEW YORK",
          state: "NY",
          postal_code: "10012-4096",
          country: "UNITED STATES",
          email: "stephen@strange.com",
          phone: "617 123 4567",
          order_timestamp: DateTime.parse("2017-08-20T00:00:00"),
          received_timestamp: DateTime.parse("2017-09-06T15:08:21"),
          shipment_status: "ONHOLD",
          order_type: "Consumer",
          shipment_date: nil,
          expected_delivery_date: nil,
          delivered_timestamp: nil,
          ship_method: "Hold, Do  Not Ship",
          ship_method_code:"HOLD",
          tracking: nil
        )
        expect(results.last.warehouse).to have_attributes(
          id: "157",
          name: "Hebron, KY",
          address: "1200 WORLDWIDE BLVD",
          city: "HEBRON",
          state: "KY",
          postal_code: "41048",
          country: "US"
        )
        expect(results.last.custom_fields).to include(
          additional_tax: "15.0",
          subtotal: "10.0",
          total: "25.0"
        )
      end
    end

    vcr_options = { cassette_name: 'shipment/where/failure' }
    context "when API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        use_invalid_api_key
        start_date = Date.new(2017, 8, 1).iso8601
        query = Newgistics::Shipment.where(start_received_timestamp: start_date)

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end
end
