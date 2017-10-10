module Newgistics
  class Api
    def get(request, response_handler)
      response = connection.get(request.path, request.body)
      response_handler.handle(response)
    end

    def post(request, response_handler)
      response = connection.post(request.path, request.body)
      response_handler.handle(response)
    end

    private

    def connection
      @connection ||= Faraday.new(url: host_url) do |faraday|
        faraday.response :logger, Newgistics.logger, bodies: true
      end
    end

    def host_url
      Newgistics.configuration.host_url
    end
  end
end
