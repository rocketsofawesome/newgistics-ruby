require 'spec_helper'

RSpec.describe Newgistics::Requests::SearchShipments do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new

      expect(request.path).to eq('/shipments.aspx')
    end
  end

  describe '#body' do
    it "serializes the search parameters properly" do
      date = Date.new.iso8601
      request = described_class.new
      request.params = {
        status: 'ONHOLD',
        start_received_timestamp: date
      }

      expect(request.body).to eql(
        'key' => Newgistics.configuration.api_key,
        'status' => 'ONHOLD',
        'startReceivedTimestamp' => date
      )
    end
  end
end
