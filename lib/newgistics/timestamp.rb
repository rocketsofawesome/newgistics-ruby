module Newgistics
  class Timestamp < Virtus::Attribute
    def coerce(value)
      if value.is_a? String
        coerce_string(value)
      else
        value
      end
    end

    private

    def coerce_string(value)
      date = value.dup
      unless includes_timezone?(value)
        date << Newgistics.time_zone.utc_offset
      end
      parse_date(date, value)
    end

    def parse_date(date, fallback)
      Time.iso8601(date).getlocal(Newgistics.local_time_zone.utc_offset)
    rescue ArgumentError
      fallback
    end

    def includes_timezone?(value)
      value =~ /Z|[+-]\d{2}:\d{2}\z/
    end
  end
end
