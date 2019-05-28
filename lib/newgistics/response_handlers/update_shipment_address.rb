module Newgistics
  module ResponseHandlers
    class UpdateShipmentAddress
      attr_reader :shipment_address_update

      def initialize(shipment_address_update)
        @shipment_address_update = shipment_address_update
      end

      def handle(response)
        PostErrors.new(shipment_address_update).handle(response)
        if shipment_address_update.errors.empty?
          handle_successful_response(response)
        end
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        shipment_address_update.success = xml.at_css('success').text
      end
    end
  end
end
