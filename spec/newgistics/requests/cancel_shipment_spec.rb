require 'spec_helper'

RSpec.describe Newgistics::Requests::CancelShipment do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Newgistics::ShipmentCancellation.new)

      expect(request.path).to eq('/cancel_shipment.aspx?apiKey=INVALID')
    end
  end

  describe '#body' do
    it 'returns a hash of the shipment cancellation attributes properly' do
      Newgistics.configure { |c| c.api_key = 'ABC123' }
      shipment_cancellation = Newgistics::ShipmentCancellation.new(
        shipment_id: 'SHIPMENT23',
        cancel_if_in_process: true,
        cancel_if_backorder: true
      )

      request = described_class.new(shipment_cancellation)

      xml = Nokogiri::XML(request.body)

      expect(xml).to have_element('cancelShipment').with_attributes(apiKey: 'ABC123')
      expect(xml).to have_element('cancelShipment').with_attributes(shipmentID: 'SHIPMENT23')
      cancel_shipment = xml.at_css('cancelShipment')
      expect(cancel_shipment).to have_element('cancelIfInProcess').with_text('true')
      expect(cancel_shipment).to have_element('cancelIfBackorder').with_text('true')
    end
  end
end
