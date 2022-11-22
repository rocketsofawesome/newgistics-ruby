require 'logger'

module Newgistics
  class DefaultLogger
    def self.build
      return Newgistics.Configuration.logger if Newgistics.Configuration.logger.present?
      return Rails.logger if defined?(Rails)
      Logger.new(STDOUT).tap do |logger|
        logger.level = Logger::INFO
      end
    end
  end
end
