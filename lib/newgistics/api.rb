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
      @connection ||= Faraday.new(url: api_base_url) do |faraday|
        faraday.adapter(Faraday.default_adapter)
        faraday.response(
          :logger,
          Newgistics.configuration.logger,
          {
            headers: Newgistics.configuration.log_http_headers,
            bodies: Newgistics.configuration.log_http_bodies,
            errors: Newgistics.configuration.log_http_errors,
          },
        ) if Newgistics.configuration.log_http
      end
    end

    def api_base_url
      Newgistics.configuration.api_base_url
    end
  end
end
