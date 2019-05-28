require 'spec_helper'

RSpec.describe Newgistics::ShipmentAddressUpdate do
  include IntegrationHelpers

  describe '#save' do
    before { use_valid_api_key }

    vcr_options = { cassette_name: 'shipment_address_update/save/success' }
    context "when the shipment address is updated successfully", vcr: vcr_options do
      it "returns true" do
        address_update = build_address_update

        expect(address_update.save).to be(true)
      end
    end

    vcr_options = { cassette_name: 'shipment_address_update/save/failure' }
    context "when the shipment address update fails", vcr: vcr_options do
      it 'sets the errors on the address update' do
        address_update = build_address_update(id: 'INVALID')

        success = address_update.save

        expect(success).to be(false)
        expect(address_update.errors).to contain_exactly('Invalid shipment ID.')
      end
    end
  end

  def build_address_update(overrides = {})
    attributes = {
      id: '107838373',
      status: 'ONHOLD'
    }.merge(overrides)
    described_class.new(attributes)
  end
end
