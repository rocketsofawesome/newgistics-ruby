module Newgistics
  module TimeParsers
    class ISO8601
      def parse(string)
        date = string.dup
        unless includes_timezone?(string)
          date << Newgistics.time_zone.utc_offset
        end
        parse_date(date, string)
      end

      private

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
end
