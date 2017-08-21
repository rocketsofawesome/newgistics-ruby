require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::SearchShipments do
  include FaradayHelpers

  describe '#handle' do
    context "when the response has a successful HTTP status" do
      it "raises a Newgistics::QueryError when there are errors in the body" do
        response_body = <<~HEREDOC
        <?xml version="1.0" encoding="UTF-8" ?>
          <response>
              <errors><error>Incorrect skus</error></errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new

        expect { response_handler.handle(response) }.
          to raise_error(Newgistics::QueryError)
      end

      it "returns an array of shipments when there are no errors" 
    end

    context "when the response has a failure HTTP status" do
      it "raises a Newgistics::QueryError" do
        response = build_response(status: 404, reason_phrase: 'Not Found')
        response_handler = described_class.new

        expect { response_handler.handle(response) }.
          to raise_error(Newgistics::QueryError)
      end
    end
  end
end