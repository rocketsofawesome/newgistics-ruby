module Newgistics
  module Requests
    class PostShipment
      attr_reader :orders

      def initialize(orders)
        @orders = orders
      end

      def path
        '/post_shipments.aspx'
      end

      def body
        xml_builder.to_xml
      end

      private

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          orders_xml(xml)
        end
      end

      def orders_xml(xml)
        xml.Orders(apiKey: api_key) do
          orders.each { |order| order_xml(order, xml) }
        end
      end

      def api_key
        Newgistics.configuration.api_key
      end

      def order_xml(order, xml)
        xml.Order(orderID: order.id) do
          xml.Warehouse(warehouseid: order.warehouse_id)
          xml.ShipMethod order.ship_method
          xml.InfoLine order.info_line
          xml.RequiresSignature order.requires_signature
          xml.IsInsured order.is_insured
          xml.InsuredValue order.insured_value
          xml.AddGiftWrap order.add_gift_wrap
          xml.GiftMessage order.gift_message
          xml.HoldForAllInventory order.hold_for_all_inventory

          order_date_xml(order, xml)
          customer_xml(order.customer, xml)
          custom_fields_xml(order, xml)
          items_xml(order.items, xml)
        end
      end

      def order_date_xml(order, xml)
        unless order.order_date.nil?
          xml.OrderDate order.order_date.strftime('%m/%d/%Y')
        end
      end

      def custom_fields_xml(object, xml)
        xml.CustomFields do
          object.custom_fields.each do |key, value|
            xml.send StringHelper.camelize(key), value
          end
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
          xml.Qty item.quantity
          xml.IsGiftWrapped item.is_gift_wrapped
          custom_fields_xml(item, xml)
        end
      end

      def customer_xml(customer, xml)
        xml.CustomerInfo do
          xml.Company customer.company
          xml.FirstName customer.first_name
          xml.LastName customer.last_name
          xml.Address1 customer.address1
          xml.Address2 customer.address2
          xml.City customer.city
          xml.State customer.state
          xml.Zip customer.zip
          xml.Country customer.country
          xml.Email customer.email
          xml.Phone customer.phone
          xml.IsResidential customer.is_residential
        end
      end
    end
  end
end
