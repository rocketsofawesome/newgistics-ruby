require "virtus"
require "nokogiri"
require "faraday"
require "tzinfo"
require 'forwardable'

require "newgistics/time_parsers"
require "newgistics/time_parsers/iso8601"
require "newgistics/time_parsers/american_datetime"
require "newgistics/api"
require "newgistics/default_logger"
require "newgistics/configuration"
require "newgistics/time_zone"
require "newgistics/timestamp"
require "newgistics/model"
require "newgistics/customer"
require "newgistics/item"
require "newgistics/order"
require "newgistics/package_item"
require "newgistics/package"
require "newgistics/product"
require "newgistics/return"
require "newgistics/inbound_return"
require "newgistics/inventory"
require "newgistics/query"
require "newgistics/errors"
require "newgistics/string_helper"
require "newgistics/shipment_cancellation"
require "newgistics/shipment_address_update"
require "newgistics/shipment_update"
require "newgistics/warehouse"
require "newgistics/requests/cancel_shipment"
require "newgistics/requests/post_shipment"
require "newgistics/requests/post_inbound_return"
require "newgistics/requests/search"
require "newgistics/requests/post_manifest"
require "newgistics/requests/cancel_manifest"
require "newgistics/requests/update_shipment_address"
require "newgistics/requests/update_shipment_contents"
require "newgistics/response_handlers/cancel_shipment"
require "newgistics/response_handlers/post_shipment"
require "newgistics/response_handlers/post_inbound_return"
require "newgistics/response_handlers/post_errors"
require "newgistics/response_handlers/search"
require "newgistics/response_handlers/update_shipment_address"
require "newgistics/response_handlers/update_shipment_contents"
require "newgistics/response_handlers/post_manifest"
require "newgistics/response_handlers/cancel_manifest"
require "newgistics/manifest_item"
require "newgistics/manifest_slip"
require "newgistics/manifest"
require "newgistics/fee"
require "newgistics/shipment"
require "newgistics/version"
require "newgistics/xml_marshaller"

module Newgistics
  class << self
    extend Forwardable

    def_delegators :@configuration, :time_zone, :local_time_zone, :logger, :logger=
  
    def configuration
      @configuration ||= Configuration.new
    end
  
    def api
      @api ||= Api.new
    end
  
    def configure
      yield(configuration)
    end
  end
end
