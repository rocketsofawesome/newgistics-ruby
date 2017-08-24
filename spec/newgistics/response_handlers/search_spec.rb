require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::Search do
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
        response_handler = build_response_handler

        expect { response_handler.handle(response) }.
          to raise_error(Newgistics::QueryError)
      end

      it "returns an array of models when there are no errors in the body" do
        response_body = <<~XML
          <?xml version="1.0" encoding="utf-8"?>
          <BogusModels>
            <BogusModel id="1">
              <SimpleAttribute>First Value</SimpleAttribute>
            </BogusModel>
            <BogusModel id="2">
              <SimpleAttribute>Second Value</SimpleAttribute>
            </BogusModel>
          </BogusModels>
        XML
        response = build_response(status: 200, body: response_body)
        response_handler = build_response_handler

        models = response_handler.handle(response)

        expect(models.map(&:id)).to eq ['1', '2']
        expect(models.map(&:simple_attribute)).
          to eq ['First Value', 'Second Value']
      end
    end

    context "when the response has a failure HTTP status" do
      it "raises a Newgistics::QueryError" do
        response = build_response(status: 404, reason_phrase: 'Not Found')
        response_handler = build_response_handler

        expect { response_handler.handle(response) }.
          to raise_error(Newgistics::QueryError)
      end
    end
  end

  def build_response_handler
    described_class.new(
      element_selector: 'BogusModels BogusModel',
      model_class: Newgistics::BogusModel
    )
  end
end
