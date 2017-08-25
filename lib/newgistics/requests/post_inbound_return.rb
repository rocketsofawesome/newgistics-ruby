module Newgistics
  module Requests
    class PostInboundReturn
      attr_reader :returns

      def initialize(returns)
        @returns = returns
      end

      def path
        '/post_inbound_returns.aspx'
      end

      def body
        xml_builder.to_xml
      end

      private

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          returns_xml(xml)
        end
      end

      def returns_xml(xml)
        xml.Returns(apiKey: api_key) do
          returns.each { |inbound_return| return_xml(inbound_return, xml) }
        end
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def return_xml(inbound_return, xml)
        xml.Return(return_attributes(inbound_return)) do
          xml.RMA inbound_return.rma
          xml.Comments inbound_return.comments

          items_xml(inbound_return.items, xml)
        end
      end

      def return_attributes(inbound_return)
        {
          id: inbound_return.shipment_id,
          orderID: inbound_return.order_id
        }.reject { |_k, v| v.nil? || v.empty? }
      end

      def items_xml(items, xml)
        xml.Items do
          items.each { |item| item_xml(item, xml) }
        end
      end

      def item_xml(item, xml)
        xml.Item do
          xml.SKU item.sku
          xml.Qty item.qty
          xml.Reason item.reason
        end
      end
    end
  end
end
