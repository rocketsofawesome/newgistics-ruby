require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::CancelManifest do
  include FaradayHelpers

  describe '#handle' do
    context "when there are no errors or warnings in the response" do
      it "sets the status of the manifest to CANCELED" do
        manifest = Newgistics::Manifest.new
        response_body = <<~XML
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
            <success>true</success>
          </response>
        XML
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.errors).to be_empty
        expect(manifest.errors).to be_empty
        expect(manifest.status).to eq('CANCELED')
      end
    end

    context "when there are errors in the response" do
      it "doesn't change the status of the manifest" do
        manifest = Newgistics::Manifest.new(status: 'CREATED')
        response_body = <<~XML
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
            <errors>
              <error>This manifest has already been canceled.</error>
            </errors>
          </response>
        XML
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.status).to eq('CREATED')
      end

      it "stores the errors in the manifest" do
        manifest = Newgistics::Manifest.new
        response_body = <<~XML
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
            <errors>
              <error>This manifest has already been canceled.</error>
            </errors>
          </response>
        XML
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.errors).to contain_exactly(
          'This manifest has already been canceled.'
        )
      end
    end
  end
end
