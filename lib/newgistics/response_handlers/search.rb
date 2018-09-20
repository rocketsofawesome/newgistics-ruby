module Newgistics
  module ResponseHandlers
    class Search
      attr_reader :model_class

      def initialize(model_class:)
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
        errors = error_nodes(xml).map(&:text)

        if errors.empty?
          build_models(xml)
        else
          raise_error(errors.join(', '))
        end
      end

      def error_nodes(xml)
        xml.css('errors error') + xml.css('Errors Error')
      end

      def build_models(xml)
        xml.css(model_class.element_selector).map do |model_xml|
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
        raise QueryError, message
      end
    end
  end
end
