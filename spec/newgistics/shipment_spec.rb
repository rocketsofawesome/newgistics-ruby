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
          order_timestamp: newgistics_time("2017-08-20T00:00:00"),
          received_timestamp: newgistics_time("2017-09-06T15:08:21.240"),
          shipment_status: "ONHOLD",
          order_type: "Consumer",
          shipped_date: nil,
          expected_delivery_date: nil,
          delivered_timestamp: nil,
          ship_method: "Hold, Do  Not Ship",
          ship_method_code:"HOLD",
          tracking: '4209492592612927005053140000004149',
          tracking_url: 'http://shipment.co/tracking/2544/4209492592612927005053140000004149'
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

  describe '#backordered?' do
    it "returns true for backordered shipments" do
      shipment = described_class.new(shipment_status: 'BACKORDER')

      expect(shipment).to be_backordered
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'SHIPPED')

      expect(shipment).not_to be_backordered
    end
  end

  describe '#canceled?' do
    it "returns true for canceled shipments" do
      shipment = described_class.new(shipment_status: 'CANCELED')

      expect(shipment).to be_canceled
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'SHIPPED')

      expect(shipment).not_to be_canceled
    end
  end

  describe '#on_hold?' do
    %w(BADADDRESS ONHOLD BADSKUHOLD CNFHOLD INVHOLD).each do |status|
      it "returns true for shipments with a #{status} status" do
        shipment = described_class.new(shipment_status: status)

        expect(shipment).to be_on_hold
      end
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'SHIPPED')

      expect(shipment).not_to be_on_hold
    end
  end

  describe '#received?' do
    it "returns true for received shipments" do
      shipment = described_class.new(shipment_status: 'RECEIVED')

      expect(shipment).to be_received
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'SHIPPED')

      expect(shipment).not_to be_received
    end
  end

  describe '#printed?' do
    it "returns true for printed shipments" do
      shipment = described_class.new(shipment_status: 'PRINTED')

      expect(shipment).to be_printed
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'SHIPPED')

      expect(shipment).not_to be_printed
    end
  end

  describe '#shipped?' do
    it "returns true for shipped shipments" do
      shipment = described_class.new(shipment_status: 'SHIPPED')

      expect(shipment).to be_shipped
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'CANCELED')

      expect(shipment).not_to be_shipped
    end
  end

  describe '#returned?' do
    it "returns true for returned shipments" do
      shipment = described_class.new(shipment_status: 'RETURNED')

      expect(shipment).to be_returned
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'BACKORDER')

      expect(shipment).not_to be_returned
    end
  end

  describe '#verified?' do
    it "returns true for verified shipments" do
      shipment = described_class.new(shipment_status: 'VERIFIED')

      expect(shipment).to be_verified
    end

    it "returns false for any other shipment_status" do
      shipment = described_class.new(shipment_status: 'SHIPPED')

      expect(shipment).not_to be_verified
    end
  end
end
