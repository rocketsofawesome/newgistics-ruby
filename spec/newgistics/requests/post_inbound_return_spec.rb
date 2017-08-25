require 'spec_helper'

RSpec.describe Newgistics::Requests::PostInboundReturn do
   describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new([])

      expect(request.path).to eq('/post_inbound_returns.aspx')
    end
  end

  describe '#body' do
    it 'serializes the inbound returns properly' do
      Newgistics.configure { |c| c.api_key = 'ABC123' }
      inbound_return = Newgistics::InboundReturn.new(
        shipment_id: 'SHIPMENT23',
        rma: '12938474',
        comments: 'Sample Comment',
        items: [
          Newgistics::Item.new(
            sku: 'BCD-123',
            qty: 2,
            reason: 'Too Big'
          )
        ]
      )
      request = described_class.new([inbound_return])

      xml = Nokogiri::XML(request.body)

      expect(xml).to have_element('Returns').with_attributes(apiKey: 'ABC123')
      expect(xml).to have_element('Returns Return').with_attributes(id: 'SHIPMENT23')
      inbound_return = xml.at_css('Return')
      expect(inbound_return).to have_element('RMA').with_text('12938474')
      expect(inbound_return).to have_element('Comments').with_text('Sample Comment')
      verify_items_xml(inbound_return.at_css('Items'))
    end
  end

  def verify_items_xml(items_xml)
      items = items_xml.css('Item')
      first_item_xml = items.first

      expect(first_item_xml).to have_element('SKU').with_text('BCD-123')
      expect(first_item_xml).to have_element('Qty').with_text('2')
      expect(first_item_xml).to have_element('Reason').with_text('Too Big')
    end
end
