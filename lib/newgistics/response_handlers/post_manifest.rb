module Newgistics
  module ResponseHandlers
    class PostManifest
      attr_reader :manifest

      def initialize(manifest)
        @manifest = manifest
      end

      def handle(response)
        PostErrors.new(manifest).handle(response)
        handle_successful_response(response) if manifest.errors.empty?
      end

      private

      def handle_successful_response(response)
        xml = Nokogiri::XML(response.body)
        manifest.id = xml.at_css('manifest')['id']
      end
    end
  end
end
