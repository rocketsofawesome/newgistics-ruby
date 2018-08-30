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
        xml.manifest_slip do
          xml.manifest_po manifest.manifest_po
          xml.manifest_name manifest.manifest_name
          xml.warehouse_id manifest.warehouse_id
          xml.status manifest.status
          xml.tracking_no manifest.tracking_no
          xml.pallet_count manifest.pallet_count
          xml.carton_count manifest.carton_count
          xml.weight manifest.weight
          xml.notes manifest.notes

          date_xml(xml, :ship_date)
          date_xml(xml, :estimated_arrival_date)
        end
      end

      def date_xml(xml, attribute)
        date = manifest.send(attribute)
        xml.send(attribute, date.strftime("%m/%d/%Y")) unless date.nil?
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
