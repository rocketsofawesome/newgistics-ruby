require 'spec_helper'

RSpec.describe Newgistics::InboundReturn do
  describe '#save' do
    context "when the inbound return is placed successfully" do
      it 'updates the inbound_return object with the shipment_id and any errors or warnings'
    end

    vcr_options = { cassette_name: 'inbound_return/save/failure' }
    context "when the inbound return fails to save", vcr: vcr_options do
      it 'updates the inbound_return object with the errors' do
        inbound_return = Newgistics::InboundReturn.new(
          shipment_id: '91755251',
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

        success = inbound_return.save

        expect(success).to eq false
        expect(inbound_return.errors.size).to eq 1
        expect(inbound_return.errors.first).to eq( 
          "Unable to create inbound return; Product SKU BCD-123 was not found"
        )
      end
    end
  end
end
