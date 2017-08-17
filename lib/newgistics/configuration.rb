module Newgistics
  class Configuration
    attr_accessor :api_key, :host_url

    def host_url
      @host_url ||= "https://" + ENV["NEWGISTICS_API_URL"]
    end

    def api_key
      @api_key ||= ENV["NEWGISTICS_API_KEY"]
    end
  end
end
