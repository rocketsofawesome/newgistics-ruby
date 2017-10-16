require 'spec_helper'

RSpec.describe Newgistics::ShipmentCancellation do
  include IntegrationHelpers

  describe '#save' do
    before { use_valid_api_key }

    vcr_options = { cassette_name: 'shipment_cancellation/save/success' }
    context "when the shipment is cancelled successfully", vcr: vcr_options do
      it "returns true" do
        shipment_cancellation = described_class.new(cancelled_attributes)

        success = shipment_cancellation.save

        expect(success).to eq true
      end

      it 'sets success' do
        shipment_cancellation = described_class.new(cancelled_attributes)

        shipment_cancellation.save

        expect(shipment_cancellation.success).to eq true
      end
    end

    vcr_options = { cassette_name: 'shipment_cancellation/save/failure' }
    context "when cancelling the shipment fails", vcr: vcr_options do
      it 'sets the errors on the shipment cancellation' do
        shipment_cancellation = described_class.new(
          cancelled_attributes(order_id: 'INVALID')
        )

        success = shipment_cancellation.save

        expect(success).to eq false
        expect(shipment_cancellation.errors.size).to eq 1
        expect(shipment_cancellation.errors.first).to eq(
         "No orders matching order ID 'INVALID' found."
        )
      end
    end
  end

  describe "#success?" do
    it "returns false if success is nil" do
      shipment_cancellation = described_class.new

      expect(shipment_cancellation.success?).to eq false
    end

    it 'returns true if success is true' do
      shipment_cancellation = described_class.new

      shipment_cancellation.success = true

      expect(shipment_cancellation.success?).to eq true
    end

    it 'returns false if success is false' do
      shipment_cancellation = described_class.new

      shipment_cancellation.success = false

      expect(shipment_cancellation.success?).to eq false
    end
  end

  def cancelled_attributes(overrides = {})
    {
      order_id: 'R684492341',
      cancel_if_backorder: true
    }.merge(overrides)
  end
end
