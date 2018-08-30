require 'spec_helper'

RSpec.describe Newgistics::Manifest do
  include IntegrationHelpers

  describe '#save' do
    vcr_options = { cassette_name: 'manifest/save/success' }
    context "when submitting the manifest succeeds", vcr: vcr_options do
      before { use_valid_api_key }

      it "sets the id on the manifest" do
        manifest = build_manifest

        manifest.save

        expect(manifest.id).to eq('450018')
      end

      it "returns true" do
        manifest = build_manifest

        expect(manifest.save).to be(true)
      end
    end

    vcr_options = { cassette_name: 'manifest/save/failure' }
    context "when submitting the manifest fails", vcr: vcr_options do
      before { use_invalid_api_key }

      it "stores the errors" do
        manifest = build_manifest

        manifest.save

        expect(manifest.errors).not_to be_empty
      end

      it "returns false" do
        manifest = build_manifest

        expect(manifest.save).to be(false)
      end
    end

    def build_manifest
      described_class.new(
        manifest_po: 'PO-00001',
        manifest_name: 'Purchase Order 1',
        status: 'SHIPPED',
        ship_date: '2018-08-29',
        contents: [
          { sku: 'SKU-1', description: 'Sku 1', original_qty: 1 }
        ]
      )
    end
  end
end
