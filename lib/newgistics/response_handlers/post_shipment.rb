module Newgistics
  module ResponseHandlers
    class PostShipment
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def handle(response)
        if response.kind_of? Net::HTTPSuccess
          handle_successful_response(response)
        else
          handle_failed_response(response)
        end
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        order.shipment_id = xml.css('shipment').first['id']
        order.errors = xml.css('errors error').map(&:text)
        order.warnings = xml.css('warnings warning').map(&:text)
      end

      def handle_failed_response(response)
        message = "Failed to save order: "
        message += "#{response.status} - #{response.reason_phrase}"

        order.errors << message
      end
    end
  end
end
