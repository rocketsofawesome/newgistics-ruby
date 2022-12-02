require 'logger'

module Newgistics
  class DefaultLogger
    def self.build
      Object.const_defined?("Rails") ? Rails.logger : build_logger
    end

    private 
    def self.build_logger
      Logger.new(STDOUT).tap do |logger|
        logger.level = Logger::INFO
      end
    end
  end
end
