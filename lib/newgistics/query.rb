module Newgistics
  class Query
    include Enumerable

    attr_reader :request, :response_handler, :conditions

    def initialize(request, response_handler)
      @request = request
      @response_handler = response_handler
      @conditions = {}
    end

    def self.build(endpoint:, element_selector:, model_class:)
      request = Requests::Search.new(endpoint)
      response_handler = ResponseHandlers::Search.new(
        element_selector: element_selector,
        model_class: model_class
      )

      new(request, response_handler)
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
      request.params = conditions
      Newgistics.api.get(request, response_handler)
    end
  end
end
