module Newgistics
  module Requests
    class UpdateShipmentContents
      attr_reader :update_shipment

      def initialize(update_shipment)
        @update_shipment = update_shipment
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
          update_shipment_xml(xml)
        end
      end

      def update_shipment_xml(xml)
        xml.Shipment(update_shipment_attributes) do
          add_items_xml(update_shipment.add_items, xml)
          remove_items_xml(update_shipment.remove_items, xml)
        end
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def update_shipment_attributes
        {
          apiKey: api_key,
          id: update_shipment.id,
          orderID: update_shipment.order_id
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
