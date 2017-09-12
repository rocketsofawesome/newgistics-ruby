module Newgistics
  class TimeZone
    attr_reader :tz_timezone

    def initialize(name)
      @tz_timezone = TZInfo::Timezone.get(name)
    end

    def utc_offset
      @utc_offset ||= formatted_utc_offset
    end

    def utc_offset_in_seconds
      current_period.utc_total_offset
    end

    private

    def current_period
      tz_timezone.current_period
    end

    def formatted_utc_offset
      seconds = utc_offset_in_seconds
      hours = seconds / 3600
      minutes = seconds % 3600 / 60
      sign = hours < 0 ? "-" : "+"
      "%s%02d:%02d" % [sign, hours.abs, minutes.abs]
    end
  end
end
