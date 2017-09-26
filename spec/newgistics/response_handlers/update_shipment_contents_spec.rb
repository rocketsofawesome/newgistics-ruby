require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::UpdateShipmentContents do
  include FaradayHelpers

  describe '#handle' do
    it 'handles a 200 response with no errors' do
      update_shipment = Newgistics::UpdateShipment.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="utf-8"?>
        <response>
          <success>true</success>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)

      response_handler = described_class.new(update_shipment)

      response_handler.handle(response)
      expect(update_shipment.errors).to be_empty
      expect(update_shipment.warnings).to be_empty
      expect(update_shipment.success).to be true
    end

    it 'handles a 200 response with errors and does not set success' do
      update_shipment = Newgistics::UpdateShipment.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="utf-8"?>
        <response>
          <errors>
            <error>Invalid shipment ID.</error>
          </errors>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(update_shipment)

      response_handler.handle(response)

      expect(update_shipment.errors).not_to be_empty
      expect(update_shipment.errors.first).to eql 'Invalid shipment ID.'
      expect(update_shipment.success).to be_nil
    end
  end
end
