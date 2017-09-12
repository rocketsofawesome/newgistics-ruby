module Newgistics
  class Configuration
    attr_reader :time_zone, :local_time_zone
    attr_accessor :api_key, :host_url

    def initialize
      self.time_zone = "America/Denver"
      self.local_time_zone = "UTC"
    end

    def host_url
      @host_url ||= "https://apistaging.newgisticsfulfillment.com"
    end

    def time_zone=(name)
      @time_zone = TimeZone.new(name)
    end

    def local_time_zone=(name)
      @local_time_zone = TimeZone.new(name)
    end
  end
end
