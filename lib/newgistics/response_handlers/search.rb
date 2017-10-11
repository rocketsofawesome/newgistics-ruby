module Newgistics
  module ResponseHandlers
    class Search
      attr_reader :element_selector, :model_class

      def initialize(element_selector:, model_class:)
        @element_selector = element_selector
        @model_class = model_class
      end

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
          build_models(xml)
        else
          raise_error(errors.join(', '))
        end
      end

      def build_models(xml)
        xml.css(element_selector).map do |model_xml|
          build_model(model_xml)
        end
      end

      def build_model(model_xml)
        model_class.new.tap do |model|
          XmlMarshaller.new.assign_attributes(model, model_xml)
        end
      end

      def handle_failed_response(response)
        raise_error "API Error: #{response.status}"
      end

      def raise_error(message)
        raise QueryError.new(message)
      end
    end
  end
end
