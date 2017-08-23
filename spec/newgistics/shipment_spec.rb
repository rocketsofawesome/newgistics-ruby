require 'spec_helper'

RSpec.describe Newgistics::Shipment do
  describe '.where' do
    vcr_options = { cassette_name: 'shipment/where/successfully' }
    context "when the shipments are queried successfully", vcr: vcr_options do
      it '.all returns a list of shipment objects' do
        start_date = Date.new(2017, 8, 1).iso8601
        end_date = Date.new(2017, 8, 22).iso8601
        Newgistics.configure { |c| c.api_key = 'ABC123' }

        results = Newgistics::Shipment.where(startReceivedTimestamp: start_date).
          where(EndReceivedTimestamp: end_date).all

        expect(results.length).to eql 6
        expect(results.first).to have_attributes(
          :order_id => "XML001",
          :name => "STEPHEN STRANGE",
          :first_name => "STEPHEN",
          :last_name => "STRANGE",
          :address1 => "75 SPRING ST FL 4",
          :city => "NEW YORK",
          :state => "NY",
          :postal_code => "10012-4096",
          :country => "UNITED STATES",
          :email => "stephen@strange.com",
          :phone => "617 123 4567",
          :order_timestamp => DateTime.parse("2017-08-20T00:00:00"),
          :received_timestamp => DateTime.parse("2017-08-21T07:22:03.413"),
          :shipment_status => "ONHOLD",
          :order_type => "Consumer",
          :shipment_date => nil,
          :expected_delivery_date => nil,
          :delivered_timestamp => nil,
          :ship_method => "Hold, Do  Not Ship",
          :ship_method_code =>"HOLD",
          :tracking => nil
          )

        expect(results.first.warehouse).to have_attributes(
          :name => "Hebron, KY",
          :address => "1200 WORLDWIDE BLVD",
          :city => "HEBRON",
          :state => "KY",
          :postal_code => "41048",
          :country => "US"
          )

        expect(results.first.custom_fields).to include(
          "additional_tax" => "15.0",
          "subtotal" => "10.0",
          "total" => "25.0"
          )
      end

      it '.each returns an enumerable object of shipment objects' do
        start_date = Date.new(2017, 8, 1).iso8601
        end_date = Date.new(2017, 8, 22).iso8601
        Newgistics.configure { |c| c.api_key = 'ABC123' }

        results = Newgistics::Shipment.where(startReceivedTimestamp: start_date).
          where(EndReceivedTimestamp: end_date).each do |shipment|
            expect(shipment).to be_kind_of(Newgistics::Shipment)
        end

      end
    end
  end
end
