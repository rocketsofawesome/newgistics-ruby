require 'spec_helper'

RSpec.describe Newgistics::Requests::UpdateShipmentContents do
   describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new([])

      expect(request.path).to eq('/update_shipment_contents.aspx')
    end
  end

  describe '#body' do
    it 'serializes the updated shipment properly' do
      Newgistics.configure { |c| c.api_key = 'ABC123' }
      order = Newgistics::Order.new(
        shipment_id: 'SHIPMENT23',
        add_items: [
          Newgistics::Item.new(
            sku: 'BCD-123',
            qty: 2,
          )
        ],
        remove_items: [
          Newgistics::Item.new(
            sku: 'AB-789',
            qty: 1,
          )
        ]
      )

      request = described_class.new(order)

      xml = Nokogiri::XML(request.body)

      expect(xml).to have_element('Shipment').with_attributes(apiKey: 'ABC123')
      expect(xml).to have_element('Shipment').with_attributes(id: 'SHIPMENT23')
      shipment = xml.at_css('Shipment')
      verify_add_items_xml(shipment.at_css('AddItems'))
      verify_remove_items_xml(shipment.at_css('RemoveItems'))
    end
  end

  def verify_add_items_xml(items_xml)
      items = items_xml.css('Item')
      first_item_xml = items.first

      expect(first_item_xml).to have_element('SKU').with_text('BCD-123')
      expect(first_item_xml).to have_element('Qty').with_text('2')
  end

  def verify_remove_items_xml(items_xml)
      items = items_xml.css('Item')
      first_item_xml = items.first

      expect(first_item_xml).to have_element('SKU').with_text('AB-789')
      expect(first_item_xml).to have_element('Qty').with_text('1')
  end
end
