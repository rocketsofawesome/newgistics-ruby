module Newgistics
  class Configuration
    attr_accessor :api_key, :host_url

    def host_url
      @host_url ||= "https://api.newgistics.com"
    end
  end
end
