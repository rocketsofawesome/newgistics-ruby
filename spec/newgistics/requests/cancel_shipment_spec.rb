require 'spec_helper'

RSpec.describe Newgistics::Requests::CancelShipment do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new([])

      expect(request.path).to eq('/cancel_shipment.aspx')
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

      body = request.body

      expect(body).to include(
        apiKey: 'ABC123',
        shipmentID: 'SHIPMENT23',
        cancelIfInProcess: true,
        cancelIfBackorder: true
      )
    end
  end
end
