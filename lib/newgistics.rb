require "virtus"
require "nokogiri"
require "faraday"
require "tzinfo"

require "newgistics/api"
require "newgistics/configuration"
require "newgistics/time_zone"
require "newgistics/timestamp"
require "newgistics/customer"
require "newgistics/item"
require "newgistics/order"
require "newgistics/product"
require "newgistics/return"
require "newgistics/inbound_return"
require "newgistics/inventory"
require "newgistics/query"
require "newgistics/errors"
require "newgistics/string_helper"
require "newgistics/warehouse"
require "newgistics/requests/post_shipment"
require "newgistics/requests/post_inbound_return"
require "newgistics/requests/search"
require "newgistics/requests/update_shipment_contents"
require "newgistics/response_handlers/post_shipment"
require "newgistics/response_handlers/post_inbound_return"
require "newgistics/response_handlers/post_errors"
require "newgistics/response_handlers/search"
require "newgistics/response_handlers/update_shipment_contents"
require "newgistics/shipment"
require "newgistics/version"
require "newgistics/xml_marshaller"

module Newgistics
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.api
    @api ||= Api.new
  end

  def self.time_zone
    configuration.time_zone
  end

  def self.local_time_zone
    configuration.local_time_zone
  end

  def self.configure
    yield(configuration)
  end
end
