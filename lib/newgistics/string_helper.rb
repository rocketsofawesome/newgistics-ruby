module Newgistics
  class StringHelper
    def self.camelize(string, upcase_first: true)
      result = string.to_s.gsub(/([a-z\d]+)(_|\z)/) { $1.capitalize }
      result = result.gsub(/\A[A-Z]/) { $&.downcase } unless upcase_first
      result
    end

    def self.underscore(string)
      string.to_s.gsub(/([a-z])([A-Z])/) { "#{$1}_#{$2}" }.downcase
    end
  end
end
