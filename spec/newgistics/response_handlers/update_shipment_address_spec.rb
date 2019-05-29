require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::UpdateShipmentAddress do
  include FaradayHelpers

  describe '#handle' do
    context "when there are no errors or warnings in the response" do
      it "stores the success value in the address update" do
        address_update = Newgistics::ShipmentAddressUpdate.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
            <success>true</success>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(address_update)

        response_handler.handle(response)

        expect(address_update).to be_success
      end
    end

    context "when there are warnings in the response" do
      it "stores the warnings on the address update" do
        address_update = Newgistics::ShipmentAddressUpdate.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
            <success>true</success>
            <warnings>
              <warning>Sample warning</warning>
            </warnings>
            <errors></errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(address_update)

        response_handler.handle(response)

        expect(address_update.warnings).to contain_exactly('Sample warning')
      end
    end

    context "when there are errors in the response" do
      it "stores the errors on the address update" do
        address_update = Newgistics::ShipmentAddressUpdate.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
            <success>false</success>
            <warnings></warnings>
            <errors>
              <error>Sample Error</error>
            </errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(address_update)

        response_handler.handle(response)

        expect(address_update.errors).to contain_exactly('Sample Error')
      end
    end
  end
end
