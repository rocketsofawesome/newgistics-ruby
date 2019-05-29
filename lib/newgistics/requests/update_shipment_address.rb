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
          xml.FirstName shipment_address_update.first_name
          xml.LastName shipment_address_update.last_name
          xml.Company shipment_address_update.company
          xml.Address1 shipment_address_update.address1
          xml.Address2 shipment_address_update.address2
          xml.City shipment_address_update.city
          xml.State shipment_address_update.state
          xml.PostalCode shipment_address_update.postal_code
          xml.Country shipment_address_update.country
          xml.Email shipment_address_update.email
          xml.Phone shipment_address_update.phone
          xml.Fax shipment_address_update.fax
          xml.IsResidential shipment_address_update.is_residential
          xml.Status shipment_address_update.status
          xml.StatusNotes shipment_address_update.status_notes
          xml.ShipMethod shipment_address_update.ship_method
        end
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
