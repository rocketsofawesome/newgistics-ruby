require 'spec_helper'

RSpec.describe Newgistics::Requests::PostManifest do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(nil)

      expect(request.path).to eq('/post_manifests.aspx')
    end
  end

  describe '#body' do
    it "serializes the manifest attributes properly" do
      Newgistics.configure { |c| c.api_key = 'ABC123' }
      manifest = Newgistics::Manifest.new(
        manifest_po: 'PO_NUMBER',
        manifest_name: 'Sample',
        warehouse_id: 'WAREHOUSE_ID',
        status: 'SHIPPED',
        tracking_no: 'TRACKING_NO',
        pallet_count: 1,
        carton_count: 2,
        weight: 25.8,
        notes: 'Some notes',
        ship_date: '2018-08-07',
        estimated_arrival_date: '2018-08-15'
      )
      request = described_class.new(manifest)

      xml = Nokogiri::XML(request.body)

      slip = xml.at_css('manifest manifest_slip')
      expect(xml).to have_element('manifests').with_attributes(apiKey: 'ABC123')
      expect(slip).to have_element('manifest_po').with_text('PO_NUMBER')
      expect(slip).to have_element('manifest_name').with_text('Sample')
      expect(slip).to have_element('warehouse_id').with_text('WAREHOUSE_ID')
      expect(slip).to have_element('status').with_text('SHIPPED')
      expect(slip).to have_element('tracking_no').with_text('TRACKING_NO')
      expect(slip).to have_element('pallet_count').with_text('1')
      expect(slip).to have_element('carton_count').with_text('2')
      expect(slip).to have_element('weight').with_text('25.8')
      expect(slip).to have_element('notes').with_text('Some notes')
      expect(slip).to have_element('ship_date').with_text('08/07/2018')
      expect(slip).to have_element('estimated_arrival_date').with_text('08/15/2018')
    end

    it "serializes the manifest contents properly" do
      manifest = Newgistics::Manifest.new(
        contents: [
          { sku: 'SKU-1', description: 'Sku 1', original_qty: 1 },
          { sku: 'SKU-2', description: 'Sku 2', original_qty: 2 }
        ]
      )
      request = described_class.new(manifest)

      xml = Nokogiri::XML(request.body)

      items = xml.css('manifest contents item')
      first_item = items.first
      second_item = items.last
      expect(first_item).to have_element('sku').with_text('SKU-1')
      expect(first_item).to have_element('description').with_text('Sku 1')
      expect(first_item).to have_element('original_qty').with_text('1')
      expect(second_item).to have_element('sku').with_text('SKU-2')
      expect(second_item).to have_element('description').with_text('Sku 2')
      expect(second_item).to have_element('original_qty').with_text('2')
    end
  end
end
