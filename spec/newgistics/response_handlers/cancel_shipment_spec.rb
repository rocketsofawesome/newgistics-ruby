require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::CancelShipment do
  include FaradayHelpers

  describe '#handle' do
    it 'handles a 200 response with no errors' do
      shipment_cancellation = Newgistics::ShipmentCancellation.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="utf-8"?>
        <response>
          <success>true</success>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)

      response_handler = described_class.new(shipment_cancellation)

      response_handler.handle(response)
      expect(shipment_cancellation.errors).to be_empty
      expect(shipment_cancellation.warnings).to be_empty
      expect(shipment_cancellation.success).to be true
    end

    it 'handles a 200 response with errors and does not set success' do
      shipment_cancellation = Newgistics::ShipmentCancellation.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="utf-8"?>
        <response>
          <errors>
            <error>Invalid shipment ID.</error>
          </errors>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(shipment_cancellation)

      response_handler.handle(response)

      expect(shipment_cancellation.errors).not_to be_empty
      expect(shipment_cancellation.errors.first).to eql 'Invalid shipment ID.'
      expect(shipment_cancellation.success).to be_nil
    end
  end
end
