module Newgistics
  module TimeParsers
    def self.iso8601
      @iso8601 ||= ISO8601.new
    end

    def self.american_datetime
      @american_datetime ||= AmericanDatetime.new
    end
  end
end
