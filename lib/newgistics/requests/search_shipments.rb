module Newgistics
  module Requests
    class SearchShipments
      attr_reader :params

      def initialize(params)
        @params = params.merge(key: Newgistics.configuration.api_key)
      end

      def path
        '/shipments.aspx'
      end

      def body
        params.
          map { |k,v| [StringHelper.camelize(k, upcase_first: false), v] }.
          to_h
      end
    end
  end
end
