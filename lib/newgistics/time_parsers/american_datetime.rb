module Newgistics
  module TimeParsers
    class AmericanDatetime
      DATE_FORMAT = "%m/%d/%Y %I:%M %p %z".freeze

      def parse(string)
        date = date_with_timezone(string)
        parse_date(date, string)
      end

      private

      def date_with_timezone(string)
        return string if includes_timezone?(string)
        "#{string} #{Newgistics.time_zone.utc_offset}"
      end

      def includes_timezone?(string)
        string =~ /[+-]\d{2}:\d{2}\z/
      end

      def parse_date(date, fallback)
        Time.strptime(date, DATE_FORMAT).
          getlocal(Newgistics.local_time_zone.utc_offset)
      rescue ArgumentError
        fallback
      end
    end
  end
end
