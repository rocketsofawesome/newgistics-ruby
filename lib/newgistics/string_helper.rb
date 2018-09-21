module Newgistics
  class StringHelper
    CAMEL_CASED_STRING_REGEX = /([a-z])([A-Z])/
    UNDERSCORED_STRING_REGEX = /([A-Za-z\d]+)(_|\z)/
    CAPITALIZED_STRING_REGEX = /\A[A-Z]/

    def self.camelize(string, upcase_first: true)
      string.dup.to_s.tap do |s|
        s.gsub!(UNDERSCORED_STRING_REGEX) { $1.capitalize! || $1 }
        s.gsub!(CAPITALIZED_STRING_REGEX) { $&.downcase! } unless upcase_first
      end
    end

    def self.underscore(string)
      string.dup.to_s.tap do |s|
        s.gsub!(CAMEL_CASED_STRING_REGEX) { "#{$1}_#{$2}" }
        s.downcase!
      end
    end
  end
end
