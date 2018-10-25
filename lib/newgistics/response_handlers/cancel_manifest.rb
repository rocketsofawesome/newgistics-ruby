module Newgistics
  module ResponseHandlers
    class CancelManifest
      attr_reader :manifest

      def initialize(manifest)
        @manifest = manifest
      end

      def handle(response)
        PostErrors.new(manifest).handle(response)
        manifest.status = 'CANCELED' if manifest.errors.empty?
      end
    end
  end
end
