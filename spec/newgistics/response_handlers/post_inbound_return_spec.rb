require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::PostInboundReturn do
  include FaradayHelpers

  describe '#handle' do
    it 'handles a 200 response with no errors' do
      inbound_return = Newgistics::InboundReturn.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="UTF-8" ?>
        <response>
            <Returns>
                <Return id="6013782" RMA="2520910" ShipmentID="69776" inbound_returnID="TEST-001" />
            </Returns>
            <warnings></warnings>
            <errors></errors>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)
      
      response_handler = described_class.new(inbound_return)

      response_handler.handle(response)
      expect(inbound_return.errors).to be_empty
      expect(inbound_return.warnings).to be_empty
      expect(inbound_return.id).to eq "6013782"
    end

    it 'handles a 200 response with errors and does not set the id' do
      inbound_return = Newgistics::InboundReturn.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="UTF-8" ?>
        <response>
            <Returns />
            <warnings></warnings>
            <errors><error>Problem processing returns</error></errors>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(inbound_return)

      response_handler.handle(response)

      expect(inbound_return.errors).not_to be_empty
      expect(inbound_return.errors.first).to eql 'Problem processing returns'
      expect(inbound_return.id).to be_nil
    end
  end
end
