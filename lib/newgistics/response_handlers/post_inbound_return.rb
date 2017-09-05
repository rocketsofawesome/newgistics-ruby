module Newgistics
  module ResponseHandlers
    class PostInboundReturn
      attr_reader :inbound_return

      def initialize(inbound_return)
        @inbound_return = inbound_return
      end

      def handle(response)
        PostErrors.new(inbound_return).handle(response)
        if inbound_return.errors.empty?
          handle_successful_response(response)
        end
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        inbound_return.id = xml.css('Return').first['ID']
      end
    end
  end
end
