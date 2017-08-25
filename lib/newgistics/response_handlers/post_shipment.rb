module Newgistics
  module ResponseHandlers
    class PostShipment
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def handle(response)
        PostErrors.new(order).handle(response)
        if order.errors.empty?
          handle_successful_response(response)
        end
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        order.shipment_id = xml.css('shipment').first['id']
      end
    end
  end
end
