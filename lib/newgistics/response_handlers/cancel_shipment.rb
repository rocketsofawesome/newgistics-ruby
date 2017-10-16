module Newgistics
  module ResponseHandlers
    class CancelShipment
      attr_reader :shipment

      def initialize(shipment)
        @shipment = shipment
      end

      def handle(response)
        PostErrors.new(shipment).handle(response)
        if shipment.errors.empty?
          handle_successful_response(response)
        end
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        shipment.success = xml.at_css('success').text
      end
    end
  end
end
