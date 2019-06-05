module Newgistics
  module Requests
    class UpdateShipmentAddress
      attr_reader :shipment_address_update, :response_handler

      def initialize(shipment_address_update, response_handler: nil)
        @shipment_address_update = shipment_address_update
        @response_handler = response_handler || default_response_handler
      end

      def path
        '/update_shipment_address.aspx'
      end

      def body
        xml_builder.to_xml
      end

      def perform
        Newgistics.api.post(self, response_handler)
      end

      private

      def default_response_handler
        ResponseHandlers::UpdateShipmentAddress.new(shipment_address_update)
      end

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          shipment_address_update_xml(xml)
        end
      end

      def shipment_address_update_xml(xml)
        xml.updateShipment(shipment_address_update_attributes) do
          xml_field(xml, 'FirstName', :first_name)
          xml_field(xml, 'LastName', :last_name)
          xml_field(xml, 'Company', :company)
          xml_field(xml, 'Address1', :address1)
          xml_field(xml, 'Address2', :address2)
          xml_field(xml, 'City', :city)
          xml_field(xml, 'State', :state)
          xml_field(xml, 'PostalCode', :postal_code)
          xml_field(xml, 'Country', :country)
          xml_field(xml, 'Email', :email)
          xml_field(xml, 'Phone', :phone)
          xml_field(xml, 'Fax', :fax)
          xml_field(xml, 'IsResidential', :is_residential)
          xml_field(xml, 'Status', :status)
          xml_field(xml, 'StatusNotes', :status_notes)
          xml_field(xml, 'ShipMethod', :ship_method)
        end
      end

      def xml_field(xml, xml_node, attribute_name)
        value = shipment_address_update.send(attribute_name)
        xml.send(xml_node, value) unless value.nil?
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def shipment_address_update_attributes
        {
          apiKey: api_key,
          id: shipment_address_update.id,
          orderID: shipment_address_update.order_id
        }.reject { |_k, v| v.nil? || v.empty? }
      end
    end
  end
end
