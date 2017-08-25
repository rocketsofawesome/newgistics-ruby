module Newgistics
  module ResponseHandlers
    class PostReturn
      attr_reader :return

      def initialize(return)
        @return = return
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
        return.errors = xml.css('errors error').map(&:text)
        return.warnings = xml.css('warnings warning').map(&:text)

        if return.errors.empty?
          return.id = xml.css('Return').first['id']
          return.rma = xml.css('Return').first['RMA']
        end
      end

      def handle_failed_response(response)
        message = "Failed to save return: "
        message += "#{response.status} - #{response.reason_phrase}"

        return.errors << message
      end
    end
  end
end
