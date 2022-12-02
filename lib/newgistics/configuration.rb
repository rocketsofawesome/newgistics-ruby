module Newgistics
  class Configuration
    attr_reader :time_zone, :local_time_zone
    attr_accessor :api_key, :api_base_url, :logger, :log_http

    def initialize
      self.time_zone = "America/Denver"
      self.local_time_zone = "UTC"
    end

    def api_base_url
      @api_base_url ||= "https://apistaging.newgisticsfulfillment.com"
    end

    def time_zone=(name)
      @time_zone = TimeZone.new(name)
    end

    def local_time_zone=(name)
      @local_time_zone = TimeZone.new(name)
    end

    def logger
      @logger ||= DefaultLogger.build
    end

    def logger=(_logger)
      @logger = _logger
    end

    def log_http
      @log_http || false
    end

    def log_http_headers
      @log_headers || false
    end

    def log_http_bodies
      @log_bodies || false
    end

    def log_http_errors
      @log_errors || true
  end
end
