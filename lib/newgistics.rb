require "virtus"
require "nokogiri"
require "faraday"

require "newgistics/api"
require "newgistics/configuration"
require "newgistics/customer"
require "newgistics/item"
require "newgistics/order"
require "newgistics/requests/post_shipment"
require "newgistics/response_handlers/post_shipment"
require "newgistics/version"

module Newgistics
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.api
    @api ||= Api.new
  end

  def self.configure
    yield(configuration)
  end
end
