module Newgistics
  module ResponseHandlers
    class PostErrors
      attr_reader :model

      def initialize(model)
        @model = model
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
        model.errors = error_nodes(xml).map(&:text)
        model.warnings = warning_nodes(xml).map(&:text)
      end

      def handle_failed_response(response)
        message = "API Error: #{response.status}"
        model.errors << message
      end

      def error_nodes(xml)
        xml.css('errors error') + xml.css('Errors Error')
      end

      def warning_nodes(xml)
        xml.css('warnings warning') + xml.css('Warnings warning')
      end
    end
  end
end
