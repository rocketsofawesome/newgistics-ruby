module Newgistics
  module Requests
    class UpdateShipmentContents
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def path
        '/update_shipment_contents.aspx'
      end

      def body
        xml_builder.to_xml
      end

      private

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          shipment_xml(xml)
        end
      end

      def shipment_xml(xml)
        xml.Shipment(shipment_attributes) do
          add_items_xml(order.add_items, xml)
          remove_items_xml(order.remove_items, xml)
        end
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def shipment_attributes
        {
          apiKey: api_key,
          id: order.shipment_id,
          orderID: order.id
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
