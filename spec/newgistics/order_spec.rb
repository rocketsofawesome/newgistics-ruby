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

        expect(order.errors).to include('Attribute "apiKey" empty or missing from "Orders" element.')
      end
    end
  end

  def order_attributes(attributes = {})
    {
      id: 'R123456789',
      ship_method: 'USPS Express',
      info_line: 'Additional order details',
      requires_signature: false,
      is_insured: false,
      add_gift_wrap: false,
      hold_for_all_inventory: true,
      order_date: '2017-08-20',
      customer: {
        first_name: 'Stephen',
        last_name: 'Strange',
        address1: '75 Spring St',
        address2: '4th Floor',
        city: 'New York',
        state: 'NY',
        zip: '10012',
        country: 'USA',
        email: 'stephen@strange.com',
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
