module Newgistics
  module Requests
    class CancelShipment
      attr_reader :shipment_cancellation

      def initialize(shipment_cancellation)
        @shipment_cancellation = shipment_cancellation
      end

      def path
        '/cancel_shipment.aspx'
      end

      def body
        mandatory_params.merge(optional_params)
      end

      private
      def mandatory_params
        {
          apiKey: Newgistics.configuration.api_key,
          shipmentID: shipment_cancellation.shipment_id,
          orderID: shipment_cancellation.order_id
        }.reject { |_k, v| v.nil? || v.empty? }
      end

      def optional_params
        {
          cancelIfInProcess: shipment_cancellation.cancel_if_in_process,
          cancelIfBackorder: shipment_cancellation.cancel_if_backorder
        }.reject { |_k, v| v.nil? }
      end
    end
  end
end
