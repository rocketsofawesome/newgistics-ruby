require 'spec_helper'

RSpec.describe Newgistics::InboundReturn do
  include IntegrationHelpers

  describe '.where' do
    vcr_options = { cassette_name: 'inbound_return/where/success' }
    context "when the api is queried successfully", vcr: vcr_options do
      it "returns an array of inbound returns" do
        use_valid_api_key
        start_date = Date.new(2017, 11, 7).iso8601
        end_date = Date.new(2017, 11, 9).iso8601

        results = Newgistics::InboundReturn.
          where(start_created_timestamp: start_date).
          where(end_created_timestamp: end_date).
          all

        inbound_return = results.first
        expect(results.size).to eq(1)
        expect(inbound_return).to have_attributes(
          id: '1799569',
          shipment_id: '92978955',
          order_id: 'R041850832',
          rma: 'RA123456789'
        )
        expect(inbound_return.items.first).to have_attributes(
          sku: '5257-525-P',
          qty: 1,
          reason: 'Box Returns'
        )
      end
    end

    vcr_options = { cassette_name: 'inbound_return/where/error', record: :new_episodes }
    context "when there's an error querying the api", vcr: vcr_options do
      it "raises a QueryError" do
        use_invalid_api_key

        expect { Newgistics::InboundReturn.where(shipment_id: '92978955').first }.
          to raise_error(Newgistics::QueryError)
      end
    end
  end

  describe '#save' do
    before { use_valid_api_key }

    vcr_options = { cassette_name: 'inbound_return/save/success' }
    context "when the inbound return is placed successfully", vcr: vcr_options do
      it "returns true" do
        inbound_return = Newgistics::InboundReturn.new(return_attributes)

        expect(inbound_return.save).to be(true)
      end

      it 'sets the id and any errors or warnings' do
        inbound_return = Newgistics::InboundReturn.new(return_attributes)

        inbound_return.save

        expect(inbound_return.id).to eq('1754253')
      end
    end

    vcr_options = { cassette_name: 'inbound_return/save/failure' }
    context "when the inbound return fails to save", vcr: vcr_options do
      it 'updates the inbound_return object with the errors' do
        inbound_return = Newgistics::InboundReturn.new(
          return_attributes(shipment_id: 'INVALID')
        )

        success = inbound_return.save

        expect(success).to eq false
        expect(inbound_return.errors.size).to eq 1
        expect(inbound_return.errors.first).to eq(
          "Unable to create inbound return; invalid shipment ID."
        )
      end
    end
  end

  def return_attributes(overrides = {})
    {
      shipment_id: '91955506',
      rma: 'RA343167887',
      comments: 'Sample Comment',
      items: [
        {
          sku: '1007-201-G',
          qty: 1,
          reason: 'Too Big'
        }
      ]
    }.merge(overrides)
  end
end
