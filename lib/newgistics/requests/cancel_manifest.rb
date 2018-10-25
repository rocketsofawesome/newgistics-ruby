module Newgistics
  module Requests
    class CancelManifest
      attr_reader :manifest

      def initialize(manifest, response_handler: nil)
        @manifest = manifest
        @response_handler = response_handler || default_response_handler
      end

      def path
        '/cancel_manifest.aspx'
      end

      def body
        { manifestId: manifest.id, key: Newgistics.configuration.api_key }
      end

      def perform
        Newgistics.api.get(self, @response_handler)
      end

      private

      def default_response_handler
        ResponseHandlers::CancelManifest.new(manifest)
      end
    end
  end
end
