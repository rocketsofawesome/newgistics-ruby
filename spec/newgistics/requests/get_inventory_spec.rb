require 'spec_helper'

RSpec.describe Newgistics::Requests::Inventory do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new

      expect(request.path).to eq('/inventory.aspx')
    end
  end

  describe '#body' do
    it "serializes the search parameters properly" do
      date = Date.new.iso8601
      request = described_class.new
      request.params = {
        sku: 'A-SFS-123',
        warehouse: 'KENTUCKY'
      }

      expect(request.body).to eql(
        'key' => Newgistics.configuration.api_key,
        'sku' => 'A-SFS-123',
        'warehouse' => 'KENTUCKY'
      )
    end
  end
end
