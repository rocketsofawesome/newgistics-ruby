module TimeHelpers
  def newgistics_time(string)
    string << Newgistics.time_zone.utc_offset
    Time.iso8601(string)
  end
end
