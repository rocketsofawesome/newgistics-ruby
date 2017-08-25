require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::PostShipment do
  include FaradayHelpers

  describe '#handle' do
    it 'handles a 200 response with no errors' do
      order = Newgistics::Order.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="UTF-8" ?>
        <response>
            <shipments>
                <shipment id="6013782" orderID="XML001" />
            </shipments>
            <warnings></warnings>
            <errors></errors>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(order)

      response_handler.handle(response)

      expect(order.errors).to be_empty
      expect(order.warnings).to be_empty
      expect(order.shipment_id).to eq "6013782"
    end

    it 'handles a 200 response with errors and does not set the shipment id' do
      order = Newgistics::Order.new
      response_body = <<~HEREDOC
        <?xml version="1.0" encoding="UTF-8" ?>
        <response>
            <shipments />
            <warnings></warnings>
            <errors><error>Incorrect skus</error></errors>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(order)

      response_handler.handle(response)

      expect(order.errors).not_to be_empty
      expect(order.errors.first).to eql 'Incorrect skus'
      expect(order.shipment_id).to be_nil
    end
  end
end
