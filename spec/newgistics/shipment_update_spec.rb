require 'spec_helper'

RSpec.describe Newgistics::ShipmentUpdate do
  include IntegrationHelpers

  describe '#save' do
    before { use_valid_api_key }

    vcr_options = { cassette_name: 'shipment_update/save/success' }
    context "when the shipment contents are changed successfully", vcr: vcr_options do
      it "returns true" do
        update_shipment = described_class.new(updated_attributes)

        success = update_shipment.save

        expect(success).to eq true
      end

      it 'sets success' do
        update_shipment = described_class.new(updated_attributes)

        update_shipment.save

        expect(update_shipment.success).to eq true
      end
    end

    vcr_options = { cassette_name: 'shipment_update/save/failure' }
    context "when the updating the shipment contents fails", vcr: vcr_options do
      it 'sets the errors on the shipment update' do
        update_shipment = described_class.new(
          updated_attributes(id: 'INVALID')
        )

        success = update_shipment.save

        expect(success).to eq false
        expect(update_shipment.errors.size).to eq 1
        expect(update_shipment.errors.first).to eq(
          "Invalid shipment ID."
        )
      end
    end
  end

  describe "#success?" do
    it "returns false if success is nil" do
      update_shipment = described_class.new

      expect(update_shipment.success?).to eq false
    end

    it 'returns true if success is true' do
      update_shipment = described_class.new

      update_shipment.success = true

      expect(update_shipment.success?).to eq true
    end

    it 'returns false if success is false' do
      update_shipment = described_class.new

      update_shipment.success = false

      expect(update_shipment.success?).to eq false
    end
  end

  def updated_attributes(overrides = {})
    {
      id: '92300628',
      add_items: [
        {
          sku: '1007-201-G',
          qty: 1,
        }
      ]
    }.merge(overrides)
  end
end
