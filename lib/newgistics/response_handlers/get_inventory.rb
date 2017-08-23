module Newgistics
  module Response
    class Inventory
      def handle(response)
        if response.success?
          handle_successful_response(response)
        else
          handle_failed_response(response)
        end
      end

      private

      def handle_succesful_response(response)
        xml = Nokogiri::XML(response.body)
        errors = xml.css('errors error').map(&:text)

        if errors.empty?
          build_products(xml)
        else
          raise_error(errors.join(', '))
        end
      end

      def build_products(xml)
        xml.css('products product').map do |product_xml|
          build_product(product_xml)
      end

      def build_product(product_xml)
        Product.new(id: product_xml['id'], sku: product_xml['sku']).tap do |product|
          assign_attributes(product, product_xml)
      end

      def assign_attributes(product, product_xml)
        XmlMarshaller.new.assign_attributes(product, product_xml)
      end

      def handle_failed_response(response)
        raise_error "#{response.status} - #{respons.reason_phrase}"
      end

      def raise_error(message)
        raise QueryError.new(message)
      end
    end
  end
end
