require 'spec_helper'

RSpec.describe Newgistics::Requests::UpdateShipmentAddress do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(nil)

      expect(request.path).to eq('/update_shipment_address.aspx')
    end
  end

  describe '#body' do
    it "serializes the shipment address update properly" do
      Newgistics.configure { |c| c.api_key = 'ABC123' }
      address_update = Newgistics::ShipmentAddressUpdate.new(
        id: '1078011123',
        company: 'Example Inc.',
        first_name: 'Scott',
        last_name: 'Summers',
        address1: '75 Spring Street',
        city: 'New York',
        state: 'NY',
        postal_code: '10012',
        country: 'US',
        email: 'scott.summers@example.com',
        phone: '617 123 4567',
        is_residential: false,
        status: 'ONHOLD',
        status_notes: 'Some notes'
      )
      request = described_class.new(address_update)

      xml = Nokogiri::XML(request.body)

      expect(xml).to have_element('updateShipment').with_attributes(
        apiKey: 'ABC123', id: '1078011123'
      )
      update = xml.at_css('updateShipment')
      expect(update).to have_element('FirstName').with_text('Scott')
      expect(update).to have_element('LastName').with_text('Summers')
      expect(update).to have_element('Company').with_text('Example Inc.')
      expect(update).to have_element('Address1').with_text('75 Spring Street')
      expect(update).to have_element('City').with_text('New York')
      expect(update).to have_element('State').with_text('NY')
      expect(update).to have_element('PostalCode').with_text('10012')
      expect(update).to have_element('Country').with_text('US')
      expect(update).to have_element('Email').with_text('scott.summers@example.com')
      expect(update).to have_element('Phone').with_text('617 123 4567')
      expect(update).to have_element('IsResidential').with_text('false')
      expect(update).to have_element('Status').with_text('ONHOLD')
      expect(update).to have_element('StatusNotes').with_text('Some notes')
    end
  end
end
