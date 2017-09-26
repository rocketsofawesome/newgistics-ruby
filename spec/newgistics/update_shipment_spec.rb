require 'spec_helper'

RSpec.describe Newgistics::UpdateShipment do
  include IntegrationHelpers

  describe '#update' do
    before { use_valid_api_key }

    vcr_options = { cassette_name: 'update_shipment_contents/update/success' }
    context "when the shipment contents are changed successfully", vcr: vcr_options do
      it "returns true" do
        update_shipment = described_class.new(updated_attributes)

        success = update_shipment.update

        expect(success).to eq true
      end

      it 'sets success' do
        update_shipment = described_class.new(updated_attributes)

        update_shipment.update

        expect(update_shipment.success).to eq true
      end
    end

    vcr_options = { cassette_name: 'update_shipment_contents/update/failure' }
    context "when the updating the shipment contents fails", vcr: vcr_options do
      it 'updates the inbound_return object with the errors' do
        update_shipment = described_class.new(
          updated_attributes(shipment_id: 'INVALID')
        )

        success = update_shipment.update

        expect(success).to eq false
        expect(update_shipment.errors.size).to eq 1
        expect(update_shipment.errors.first).to eq(
          "Invalid shipment ID."
        )
      end
    end
  end

  describe "#success?" do
    before { use_valid_api_key }

    context "before the request is sent" do
      it "returns false" do
        update_shipment = described_class.new(updated_attributes)

        expect(update_shipment.success?).to eq false
      end
    end

    vcr_options = { cassette_name: 'update_shipment_contents/update/success' }
    context "when the shipment contents are changed successfully", vcr: vcr_options do
      it 'returns true' do
        update_shipment = described_class.new(updated_attributes)

        update_shipment.update

        expect(update_shipment.success?).to eq true
      end
    end

    vcr_options = { cassette_name: 'update_shipment_contents/update/failure' }
    context "when the updating the shipment contents fails", vcr: vcr_options do
      it 'returns false' do
        update_shipment = described_class.new(
          updated_attributes(shipment_id: 'INVALID')
        )

        update_shipment.update

        expect(update_shipment.success?).to eq false
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
end
