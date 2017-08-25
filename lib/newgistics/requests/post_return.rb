module Newgistics
  module Requests
    class PostReturn
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
          returns.each { |return| return_xml(return, xml) }
        end
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def return_xml(return, xml)
        xml.Return(id: return.id) do
          xml.RMA return.rma

          items_xml(return.items, xml)
        end
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
