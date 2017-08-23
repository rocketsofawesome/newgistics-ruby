require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::Inventory do
  include FaradayHelpers

  describe '#handle' do
    context "when the response has a successful HTTP status" do
      it "raises a Newgistics::QueryError when there are errors in the body" do
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
            <errors><error>Incorrect API Key</error></errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new

        expect { response_handler.handle(response) }.
          to raise_error(Newgistics::QueryError)
      end

      it "returns an array of products when there are no errors in the body" do
        response_body = <<~XML
          <?xml version="1.0" encoding="utf-8"?>
          <response>
            <products>
              <product id="1" sku="ACD-243">
                <putawayQuantity>0</putawayQuantity>
                <quarantineQuantity>0</quarantineQuantity>
                <damagedQuantity>5</damagedQuantity>
                <expiredQuantity>0</expiredQuantity>
                <recalledQuantity>0</recalledQuantity>
                <currentQuantity>1134</currentQuantity>
                <kittingQuantity>0</kittingQuantity>
                <pendingQuantity>1</pendingQuantity>
                <availableQuantity>1133</availableQuantity>
              </product>
              <product id="2" sku="BBB-243">
                <putawayQuantity>1</putawayQuantity>
                <quarantineQuantity>1</quarantineQuantity>
                <damagedQuantity>6</damagedQuantity>
                <expiredQuantity>1</expiredQuantity>
                <recalledQuantity>1</recalledQuantity>
                <currentQuantity>11</currentQuantity>
                <kittingQuantity>2</kittingQuantity>
                <pendingQuantity>2</pendingQuantity>
                <availableQuantity>12</availableQuantity>
              </product>
            </products>
          </response>
        XML
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new

        products = response_handler.handle(response)

        expect(products.map(&:id)).to eq ['1', '2']
        expect(products.map(&:sku)).to eq ['ACD-243', 'BBB-243']
        expect(products.map(&:putaway_quantity)).to eq [0, 1]
        expect(products.map(&:quarantine_quantity)).to eq [0, 1]
        expect(products.map(&:damaged_quantity)).to eq [5, 6]
        expect(products.map(&:expired_quantity)).to eq [0, 1]
        expect(products.map(&:recalled_quantity)).to eq [0, 1]
        expect(products.map(&:current_quantity)).to eq [1134, 11]
        expect(products.map(&:kitting_quantity)).to eq [0, 2]
        expect(products.map(&:pending_quantity)).to eq [1, 2]
        expect(products.map(&:available_quantity)).to eq [1133, 12]
      end
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
