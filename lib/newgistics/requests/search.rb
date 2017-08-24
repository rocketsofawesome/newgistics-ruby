module Newgistics
  module Requests
    class Search
      attr_reader :path, :params

      def initialize(path)
        @path = path
      end

      def params=(params)
        @params = params.merge(key: Newgistics.configuration.api_key)
      end

      def body
        params.
          map { |k,v| [StringHelper.camelize(k, upcase_first: false), v] }.
          to_h
      end
    end
  end
end
