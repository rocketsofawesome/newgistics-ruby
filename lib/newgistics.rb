require "virtus"
require "nokogiri"
require "faraday"

require "newgistics/api"
require "newgistics/configuration"
require "newgistics/customer"
require "newgistics/item"
require "newgistics/order"
require "newgistics/query"
require "newgistics/errors"
require "newgistics/string_helper"
require "newgistics/requests/post_shipment"
require "newgistics/requests/search_shipments"
require "newgistics/response_handlers/post_shipment"
require "newgistics/response_handlers/search_shipments"
require "newgistics/shipment"
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
