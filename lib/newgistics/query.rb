module Newgistics
  class Query
    include Enumerable

    attr_reader :request_class, :response_handler, :conditions

    def initialize(request_class, response_handler)
      @request_class = request_class
      @response_handler = response_handler
      @conditions = {}
    end

    def where(conditions)
      @conditions.merge!(conditions)
      self
    end

    def all
      results.to_a
    end

    def each
      results.each { |result| yield(result) }
    end

    private

    def results
      request = request_class.new(conditions)
      Newgistics.api.get(request, response_handler)
    end
  end
end
