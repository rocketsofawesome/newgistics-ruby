module Newgistics
  module Requests
    class CancelShipment
      attr_reader :shipment_cancellation, :response_handler

      def initialize(shipment_cancellation, response_handler: nil)
        @shipment_cancellation = shipment_cancellation
        @response_handler = response_handler || default_response_handler
      end

      def path
        "/cancel_shipment.aspx?#{URI.encode_www_form(mandatory_params.merge(optional_params))}"
      end

      def body
        xml_builder.to_xml
      end

      def perform
        Newgistics.api.post(self, response_handler)
      end

      private

      def default_response_handler
        ResponseHandlers::CancelShipment.new(shipment_cancellation)
      end

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          shipment_cancellation_xml(xml)
        end
      end

      def shipment_cancellation_xml(xml)
        xml.cancelShipment(mandatory_params) do
          cancel_if_in_process(xml)
          cancel_if_backorder(xml)
        end
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def mandatory_params
         {
          apiKey: api_key,
          shipmentID: shipment_cancellation.shipment_id,
          orderID: shipment_cancellation.order_id
        }.reject { |_k, v| v.nil? || v.empty? }
      end

      def cancel_if_in_process(xml)
        xml.cancelIfInProcess shipment_cancellation.cancel_if_in_process
      end

      def cancel_if_backorder(xml)
        xml.cancelIfBackorder shipment_cancellation.cancel_if_backorder
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
