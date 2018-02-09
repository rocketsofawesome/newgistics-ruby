module TimeHelpers
  def newgistics_time(string)
    time_string = string.dup
    time_string << Newgistics.time_zone.utc_offset
    Time.iso8601(time_string)
  end
end
