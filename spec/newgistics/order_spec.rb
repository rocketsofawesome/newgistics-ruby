require 'spec_helper'

RSpec.describe Newgistics::Order do
  include IntegrationHelpers

  describe '#save' do
    vcr_options = { cassette_name: 'order/save/successfully' }
    context "when the order is placed successfully", vcr: vcr_options do
      before { use_valid_api_key }

      it 'updates the order object with the shipment_id and any errors or warnings' do
        order = described_class.new(order_attributes)

        order.save

        expect(order.shipment_id).not_to be_nil
      end

      it "returns true" do
        order = described_class.new(order_attributes)

        expect(order.save).to be(true)
      end
    end

    vcr_options = { cassette_name: 'order/save/failure' }
    context "when placing the order fails", vcr: vcr_options do
      before { use_invalid_api_key }

      it "returns false" do
        order = described_class.new(order_attributes)

        expect(order.save).to be(false)
      end

      it "saves the errors on the order" do
        order = described_class.new(order_attributes)

        order.save

        expect(order.errors).to include('Invalid API key')
      end
    end
  end

  describe '#update' do
    before { use_valid_api_key }

    vcr_options = { cassette_name: 'update_shipment_contents/update/success' }
    context "when the shipment contents are changed successfully", vcr: vcr_options do
      it "returns true" do
        order = Newgistics::Order.new(updated_attributes)

        success = order.update

        expect(success).to eq true
      end

      it 'sets success' do
        order = Newgistics::Order.new(updated_attributes)

        order.update

        expect(order.success).to eq true
      end
    end

    vcr_options = { cassette_name: 'update_shipment_contents/update/failure' }
    context "when the updating the shipment contents fails", vcr: vcr_options do
      it 'updates the inbound_return object with the errors' do
        order = Newgistics::Order.new(
          updated_attributes(shipment_id: 'INVALID')
        )

        success = order.update

        expect(success).to eq false
        expect(order.errors.size).to eq 1
        expect(order.errors.first).to eq(
          "Invalid shipment ID."
        )
      end
    end
  end

  def updated_attributes(overrides = {})
    {
      shipment_id: '92300642',
      add_items: [
        {
          sku: '1007-201-G',
          qty: 1,
        }
      ]
    }.merge(overrides)
  end

  def order_attributes(attributes = {})
    {
      id: 'R987654321',
      ship_method: 'USPS Express',
      info_line: 'Additional order details',
      requires_signature: false,
      is_insured: false,
      add_gift_wrap: false,
      hold_for_all_inventory: true,
      order_date: '2017-08-20',
      customer: {
        first_name: 'Wade',
        last_name: 'Wilson',
        address1: '75 Spring St',
        address2: '4th Floor',
        city: 'New York',
        state: 'NY',
        zip: '10012',
        country: 'USA',
        email: 'wade@wilson.com',
        phone: '617 123 4567',
        is_residential: false
      },
      custom_fields: {
        subtotal: 10.0,
        additional_tax: 15.0,
        total: 25.0
      },
      items: [
        { sku: '1007-201-G', qty: 1, is_gift_wrapped: false },
        {
          sku: '1008-240-C',
          qty: 2,
          is_gift_wrapped: true,
          custom_fields: {
            gift_message: 'A sample message'
          }
        }
      ]
    }.merge(attributes)
  end
end
