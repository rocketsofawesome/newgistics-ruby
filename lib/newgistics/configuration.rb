module Newgistics
  class Configuration
    attr_reader :time_zone
    attr_accessor :api_key, :host_url

    def initialize
      self.time_zone = "America/Denver"
    end

    def host_url
      @host_url ||= "https://apistaging.newgisticsfulfillment.com"
    end

    def time_zone=(name)
      @time_zone = TimeZone.new(name)
    end
  end
end
