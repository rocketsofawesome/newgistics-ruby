module Newgistics
  class Timestamp < Virtus::Attribute
    accept_options :parser

    parser TimeParsers.iso8601

    def coerce(value)
      if value.is_a? String
        options[:parser].parse(value)
      else
        value
      end
    end
  end
end
