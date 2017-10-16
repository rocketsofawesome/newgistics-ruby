module Newgistics
  module Requests
    class UpdateShipmentContents
      attr_reader :shipment_update, :response_handler

      def initialize(shipment_update, response_handler: nil)
        @shipment_update = shipment_update
        @response_handler = response_handler || default_response_handler
      end

      def path
        '/update_shipment_contents.aspx'
      end

      def body
        xml_builder.to_xml
      end

      def perform
        Newgistics.api.post(self, response_handler)
      end

      private

      def default_response_handler
        ResponseHandlers::UpdateShipmentContents.new(shipment_update)
      end

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          shipment_update_xml(xml)
        end
      end

      def shipment_update_xml(xml)
        xml.Shipment(shipment_update_attributes) do
          add_items_xml(shipment_update.add_items, xml)
          remove_items_xml(shipment_update.remove_items, xml)
        end
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def shipment_update_attributes
        {
          apiKey: api_key,
          id: shipment_update.id,
          orderID: shipment_update.order_id
        }.reject { |_k, v| v.nil? || v.empty? }
      end

      def add_items_xml(items, xml)
        xml.AddItems do
          items.each { |item| item_xml(item, xml) }
        end
      end

      def remove_items_xml(items, xml)
        xml.RemoveItems do
          items.each { |item| item_xml(item, xml) }
        end
      end

      def item_xml(item, xml)
        xml.Item do
          xml.SKU item.sku
          xml.Qty item.qty
        end
      end
    end
  end
end
