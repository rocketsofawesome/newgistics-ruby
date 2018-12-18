require 'spec_helper'

RSpec.describe Newgistics::Manifest do
  include IntegrationHelpers

  describe '.where' do
    vcr_options = { cassette_name: 'manifest/where/success' }
    context "when the query succeeds", vcr: vcr_options do
      before { use_valid_api_key }

      it "returns an array of manifests" do
        manifests = described_class.where(status: 'SHIPPED').all

        manifest = manifests.first

        expect(manifests.size).to eq(2)
        expect(manifest.manifest_slip).to have_attributes(
          manifest_id: '394408',
          manifest_po: '100167',
          manifest_name: 'CFL (Duplicate of M393353)',
          status: 'SHIPPED',
          shipped_date: newgistics_time('2018-01-11T00:00:00'),
          shipped_via: 'Freight',
          no_pallets: 0,
          no_cartons: 23
        )
        expect(manifest.contents.size).to eq(3)
        expect(manifest.contents.first).to have_attributes(
          sku: '8084-214-H',
          upc: '8084-214-H',
          description: 'SOFT DOLPHIN SHORT ECLIPSE',
          original_qty: 85,
          received_qty: 0,
          variance: -85,
          damaged_qty: 0
        )
      end
    end

    vcr_options = { cassette_name: 'manifest/where/failure' }
    context "when the query fails", vcr: vcr_options do
      before { use_invalid_api_key }

      it "raises an error" do
        expect { described_class.where(status: 'SHIPPED').all }.
          to raise_error(Newgistics::QueryError)
      end
    end
  end

  describe '#id=' do
    it "sets the id on the manifest slip" do
      manifest = described_class.new

      manifest.id = 1

      expect(manifest.manifest_slip).to have_attributes(manifest_id: '1')
    end
  end

  describe '#id' do
    it "retrieves the id from the manifest slip" do
      manifest = described_class.new(manifest_slip: { manifest_id: 2 })

      expect(manifest.id).to eq('2')
    end
  end

  describe '#status=' do
    it "sets the status on the manifest slip" do
      manifest = described_class.new

      manifest.status = 'SHIPPED'

      expect(manifest.manifest_slip.status).to eq('SHIPPED')
    end
  end

  describe '#status' do
    it "retrieves the status from the manifest slip" do
      manifest = described_class.new(manifest_slip: { status: 'CREATED' })

      expect(manifest.status).to eq('CREATED')
    end
  end

  describe '#cancel' do
    vcr_options = { cassette_name: 'manifest/cancel/success' }
    context "when canceling the manifest succeeds", vcr: vcr_options do
      before { use_valid_api_key }

      it "updates the status on the manifest" do
        manifest = described_class.new(id: 468681, status: 'CREATED')

        manifest.cancel

        expect(manifest.status).to eq('CANCELED')
      end

      it "returns true" do
        manifest = described_class.new(id: 468681)

        expect(manifest.cancel).to be(true)
      end
    end

    vcr_options = { cassette_name: 'manifest/cancel/failure' }
    context "when canceling the manifest fails", vcr: vcr_options do
      before { use_valid_api_key }

      it "doesn't change the status on the manifest" do
        manifest = described_class.new(id: 468679, status: 'CREATED')

        manifest.cancel

        expect(manifest.status).to eq('CREATED')
      end

      it "stores the errors on the manifest" do
        manifest = described_class.new(id: 468679)

        manifest.cancel

        expect(manifest.errors).
          to contain_exactly('This manifest has already been canceled')
      end

      it "returns false" do
        manifest = described_class.new(id: 468679)

        expect(manifest.cancel).to be(false)
      end
    end
  end

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
        manifest_slip: {
          manifest_po: 'PO-00001',
          manifest_name: 'Purchase Order 1',
          status: 'SHIPPED',
          ship_date: '2018-08-29'
        },
        contents: [
          { sku: 'SKU-1', description: 'Sku 1', original_qty: 1 }
        ]
      )
    end
  end
end
