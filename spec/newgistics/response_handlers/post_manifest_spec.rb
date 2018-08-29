require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::PostManifest do
  include FaradayHelpers

  describe '#handle' do
    context "when there are no errors or warnings in the response" do
      it "sets the id on the manifest" do
        manifest = Newgistics::Manifest.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
              <manifests>
                  <manifest id="12345" manifest_po="PO-0001" />
              </manifests>
              <warnings></warnings>
              <errors></errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.errors).to be_empty
        expect(manifest.warnings).to be_empty
        expect(manifest.id).to eq "12345"
      end
    end

    context "when there are errors in the response" do
      it "stores the errors on the manifest" do
        manifest = Newgistics::Manifest.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
              <manifests />
              <warnings></warnings>
              <errors>
                <error>Sample Error</error>
              </errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.errors).to contain_exactly('Sample Error')
      end

      it "doesn't set the id on the manifest" do
        manifest = Newgistics::Manifest.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
              <manifests />
              <warnings></warnings>
              <errors>
                <error>Sample Error</error>
              </errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.id).to be_nil
      end
    end

    context "when there are warnings in the response" do
      it "stores the warnings on the manifest" do
        manifest = Newgistics::Manifest.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
              <manifests>
                <manifest id="12345" />
              </manifests>
              <warnings>
                <warning>A sample warning</warning>
              </warnings>
              <errors></errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.warnings).to contain_exactly("A sample warning")
      end

      it "sets the id on the manifest" do
        manifest = Newgistics::Manifest.new
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
              <manifests>
                <manifest id="12345" />
              </manifests>
              <warnings>
                <warning>A sample warning</warning>
              </warnings>
              <errors></errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new(manifest)

        response_handler.handle(response)

        expect(manifest.id).to eq("12345")
      end
    end
  end
end
