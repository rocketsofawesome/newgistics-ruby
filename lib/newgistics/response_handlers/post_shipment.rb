module Newgistics
  module ResponseHandlers
    class PostShipment
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def handle(response)
        if response.success?
          handle_successful_response(response)
        else
          handle_failed_response(response)
        end
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        order.errors = xml.css('errors error').map(&:text)
        order.warnings = xml.css('warnings warning').map(&:text)

        if order.errors.empty?
          order.shipment_id = xml.css('shipment').first['id']
        end
      end

      def handle_failed_response(response)
        message = "Failed to save order: "
        message += "#{response.status} - #{response.reason_phrase}"

        order.errors << message
      end
    end
  end
end
