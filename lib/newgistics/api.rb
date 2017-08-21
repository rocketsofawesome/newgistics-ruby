module Newgistics
  class Api
    def post(request, response_handler)
      response = connection.post(request.path, request.body)
      response_handler.handle(response)
    end

    private

    def connection
      @connection ||= Faraday.new(url: host_url)
    end

    def host_url
      Newgistics.configuration.host_url
    end
  end
end
