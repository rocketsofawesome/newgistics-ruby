require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::PostErrors do
  include FaradayHelpers

  describe '#handle' do
    it 'handles a 200 response with errors and warnings' do
      bogus_model = Newgistics::BogusModel.new()
      response_body = <<~HEREDOC
      <?xml version="1.0" encoding="UTF-8" ?>
        <response>
            <BogusModel>
                <SimpleAttribute />
            </BogusModel>
            <warnings><warning>The order did not go through</warning></warnings>
            <errors><error>Incorrect skus</error></errors>
        </response>
      HEREDOC
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(bogus_model)

      response_handler.handle(response)

      expect(bogus_model.errors.length).to eq 1
      expect(bogus_model.warnings.length).to eq 1
      expect(bogus_model.errors.first).to eq "Incorrect skus"
      expect(bogus_model.warnings.first).to eq "The order did not go through"
    end

    it 'handles a 404 response' do
      bogus_model = Newgistics::BogusModel.new
      response = build_response(status: 404, reason_phrase: 'Not Found')
      response_handler = described_class.new(bogus_model)

      response_handler.handle(response)

      expect(bogus_model.errors.length).to eq 1
      expect(bogus_model.errors.first).to eq "Failed to save model: 404 - Not Found"
    end
  end
end
