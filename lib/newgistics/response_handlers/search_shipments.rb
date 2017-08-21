module Newgistics
  module ResponseHandlers
    class SearchShipments
      def handle(response)
        if response.success?
          handle_successful_response(response)
        else
          handle_failed_response(response)
        end
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        errors = xml.css('errors error').map(&:text)

        if errors.empty?
          build_shipments(xml)
        else
          raise_error(errors.join(', '))
        end
      end

      def build_shipments(xml)
        xml.css('Shipments Shipment').map do |shipment_xml|
          build_shipment(shipment_xml)
        end
      end

      def build_shipment(shipment_xml)
        Shipment.new(id: shipment_xml['id']).tap do |shipment|
          assign_attributes(shipment, shipment_xml)
        end
      end

      def assign_attributes(shipment, shipment_xml)
        shipment_xml.elements.each do |element|
          next if element.elements.any?
          setter = "#{StringHelper.underscore(element.name)}="
          shipment.send(setter, element.text) if shipment.respond_to?(setter)
        end
      end

      def handle_failed_response(response)
        raise_error "#{response.status} - #{response.reason_phrase}"
      end

      def raise_error(message)
        raise QueryError.new(message)
      end
    end
  end
end
