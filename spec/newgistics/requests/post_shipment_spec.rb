require 'spec_helper'

RSpec.describe Newgistics::Requests::PostShipment do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(nil)

      expect(request.path).to eq('/post_shipments.aspx')
    end
  end

  describe '#body' do
    it "serializes the orders appropriately" do
      Newgistics.configure { |c| c.api_key = 'ABC123' }
      order = Newgistics::Order.new(
        id: 'XML001',
        warehouse_id: 'WAREHOUSE_ID',
        ship_method: 'USPS',
        info_line: 'Additional order details',
        requires_signature: false,
        is_insured: false,
        add_gift_wrap: false,
        hold_for_all_inventory: true,
        allow_duplicate: false,
        order_date: '2017-08-20',
        reference_1: 'Reference 1',
        reference_2: 'Reference 2',
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
        drop_ship_info: {
          company_name: "Box",
          address: "123 Broadway",
          city: "New York",
          state: "New York",
          zip: "10012"
        },
        custom_fields: {
          subtotal: 10.0,
          additional_tax: 15.0,
          total: 25.0
        },
        items: [
          { sku: 'SKU1', qty: 1, is_gift_wrapped: false },
          {
            sku: 'SKU2',
            qty: 2,
            is_gift_wrapped: true,
            custom_fields: {
              gift_message: 'A sample message'
            }
          }
        ]
      )
      request = described_class.new(order)

      xml = Nokogiri::XML(request.body)

      expect(xml).to have_element('Orders').with_attributes(apiKey: 'ABC123')
      expect(xml).to have_element('Order').with_attributes(orderID: 'XML001')
      verify_order_xml(xml.at_css('Order'))
      verify_customer_xml(xml.at_css('Order CustomerInfo'))
      verify_custom_fields_xml(xml.at_css('Order CustomFields'))
      verify_drop_ship_info_xml(xml.at_css('Order DropShipInfo'))
      verify_items_xml(xml.at_css('Order Items'))
    end


    def verify_order_xml(order_xml)
      expect(order_xml).to have_element('Warehouse').
        with_attributes(warehouseid: 'WAREHOUSE_ID')
      expect(order_xml).to have_element('ShipMethod').with_text('USPS')
      expect(order_xml).to have_element('InfoLine').
        with_text('Additional order details')
      expect(order_xml).to have_element('RequiresSignature').with_text('false')
      expect(order_xml).to have_element('IsInsured').with_text('false')
      expect(order_xml).to have_element('AddGiftWrap').with_text('false')
      expect(order_xml).to have_element('HoldForAllInventory').with_text('true')
      expect(order_xml).to have_element('OrderDate').with_text('08/20/2017')
      expect(order_xml).to have_element('AllowDuplicate').with_text('false')
      expect(order_xml).to have_element('Reference1').with_text('Reference 1')
      expect(order_xml).to have_element('Reference2').with_text('Reference 2')
    end

    def verify_customer_xml(customer_xml)
      expect(customer_xml).to have_element('FirstName').with_text('Stephen')
      expect(customer_xml).to have_element('LastName').with_text('Strange')
      expect(customer_xml).to have_element('Address1').with_text('75 Spring St')
      expect(customer_xml).to have_element('Address2').with_text('4th Floor')
      expect(customer_xml).to have_element('City').with_text('New York')
      expect(customer_xml).to have_element('State').with_text('NY')
      expect(customer_xml).to have_element('Zip').with_text('10012')
      expect(customer_xml).to have_element('Country').with_text('USA')
      expect(customer_xml).to have_element('Email').with_text('stephen@strange.com')
      expect(customer_xml).to have_element('Phone').with_text('617 123 4567')
      expect(customer_xml).to have_element('IsResidential').with_text('false')
    end

    def verify_custom_fields_xml(custom_fields_xml)
      expect(custom_fields_xml).to have_element('Subtotal').with_text('10.0')
      expect(custom_fields_xml).to have_element('AdditionalTax').with_text('15.0')
      expect(custom_fields_xml).to have_element('Total').with_text('25.0')
    end

    def verify_drop_ship_info_xml(drop_ship_info_xml)
      expect(drop_ship_info_xml).to have_element('CompanyName').with_text('Box')
      expect(drop_ship_info_xml).to have_element('Address').with_text('123 Broadway')
      expect(drop_ship_info_xml).to have_element('City').with_text('New York')
      expect(drop_ship_info_xml).to have_element('State').with_text('New York')
      expect(drop_ship_info_xml).to have_element('Zip').with_text('10012')
    end

    def verify_items_xml(items_xml)
      items = items_xml.css('Item')
      first_item_xml = items.first
      second_item_xml = items.last

      expect(first_item_xml).to have_element('SKU').with_text('SKU1')
      expect(first_item_xml).to have_element('Qty').with_text('1')
      expect(first_item_xml).to have_element('IsGiftWrapped').with_text('false')

      expect(second_item_xml).to have_element('SKU').with_text('SKU2')
      expect(second_item_xml).to have_element('Qty').with_text('2')
      expect(second_item_xml).to have_element('IsGiftWrapped').with_text('true')
      expect(second_item_xml).to have_element('CustomFields GiftMessage').
        with_text('A sample message')
    end
  end
end
