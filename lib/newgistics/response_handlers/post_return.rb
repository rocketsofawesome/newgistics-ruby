module Newgistics
  module ResponseHandlers
    class PostReturn
      attr_reader :inbound_return

      def initialize(inbound_return)
        @inbound_return = inbound_return
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
        inbound_return.errors = xml.css('errors error').map(&:text)
        inbound_return.warnings = xml.css('warnings warning').map(&:text)

        if inbound_return.errors.empty?
          inbound_return.id = xml.css('Return').first['id']
          inbound_return.rma = xml.css('Return').first['RMA']
        end
      end

      def handle_failed_response(response)
        message = "Failed to save return: "
        message += "#{response.status} - #{response.reason_phrase}"

        inbound_return.errors << message
      end
    end
  end
end
