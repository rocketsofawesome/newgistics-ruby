require 'spec_helper'

RSpec.describe Newgistics::Requests::CancelManifest do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(nil)

      expect(request.path).to eq('/cancel_manifest.aspx')
    end
  end

  describe '#body' do
    it "includes the manifest id" do
      manifest = Newgistics::Manifest.new(id: '12345')
      request = described_class.new(manifest)

      expect(request.body).to eq(
        manifestId: '12345',
        key: Newgistics.configuration.api_key
      )
    end
  end
end
