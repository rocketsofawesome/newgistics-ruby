module Newgistics
  module Requests
    class Inventory
      attr_reader :params

      def params=(params)
        @params = params.merge(key: Newgistics.configuration.api_key)
      end

      def path
        '/inventory.aspx'
      end

      def body
        params.
          map { |k,v| [StringHelper.camelize(k, upcase_first: false), v] }.
          to_h
      end
    end
  end
end
