module Newgistics
  module Requests
    class PostManifest
      attr_reader :manifest, :response_handler

      def initialize(manifest, response_handler: nil)
        @manifest = manifest
        @response_handler = response_handler || default_response_handler
      end

      def path
        '/post_manifests.aspx'
      end

      def body
        xml_builder.to_xml
      end

      def perform
        Newgistics.api.post(self, response_handler)
      end

      private

      def api_key
        Newgistics.configuration.api_key
      end

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          manifests_xml(xml)
        end
      end

      def manifests_xml(xml)
        xml.manifests(apiKey: api_key) do
          manifest_xml(xml)
        end
      end

      def manifest_xml(xml)
        xml.manifest do
          manifest_slip_xml(xml)
          contents_xml(xml)
        end
      end

      def manifest_slip_xml(xml)
        manifest_slip = manifest.manifest_slip || ManifestSlip.new

        xml.manifest_slip do
          xml.manifest_po manifest_slip.manifest_po
          xml.manifest_name manifest_slip.manifest_name
          xml.warehouse_id manifest_slip.warehouse_id
          xml.status manifest_slip.status
          xml.tracking_no manifest_slip.tracking_no
          xml.pallet_count manifest_slip.pallet_count
          xml.carton_count manifest_slip.carton_count
          xml.weight manifest_slip.weight
          xml.notes manifest_slip.notes
          xml.ship_date format_date(manifest_slip.ship_date)
          xml.estimated_arrival_date format_date(
            manifest_slip.estimated_arrival_date
          )
        end
      end

      def format_date(date)
        date.strftime("%m/%d/%Y") if date.respond_to?(:strftime)
      end

      def contents_xml(xml)
        xml.contents do
          manifest.contents.each { |item| item_xml(item, xml) }
        end
      end

      def item_xml(item, xml)
        xml.item do
          xml.sku item.sku
          xml.description item.description
          xml.original_qty item.original_qty
          xml.received_qty item.received_qty
        end
      end

      def default_response_handler
        ResponseHandlers::PostManifest.new(manifest)
      end
    end
  end
end
