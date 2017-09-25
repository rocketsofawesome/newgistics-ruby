module Newgistics
  class Order
    include Virtus.model

    attribute :id, String
    attribute :warehouse_id, String
    attribute :customer, Customer
    attribute :drop_ship_info, Hash
    attribute :order_date, Date
    attribute :ship_method, String
    attribute :info_line, String
    attribute :requires_signature, Boolean
    attribute :is_insured, Boolean
    attribute :insured_value, Float
    attribute :add_gift_wrap, Boolean
    attribute :gift_message, String
    attribute :hold_for_all_inventory, Boolean
    attribute :custom_fields, Hash
    attribute :items, Array[Item]

    attribute :add_items, Array[Item]
    attribute :remove_items, Array[Item]
    attribute :success, Boolean

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []
    attribute :shipment_id, String

    def save
      request = Requests::PostShipment.new([self])
      response_handler = ResponseHandlers::PostShipment.new(self)

      Newgistics.api.post(request, response_handler)

      errors.empty?
    end

    def update
      request = Requests::UpdateShipmentContents.new(self)
      response_handler = ResponseHandlers::UpdateShipmentContents.new(self)

      Newgistics.api.post(request, response_handler)

      success || errors.empty?
    end
  end
end
