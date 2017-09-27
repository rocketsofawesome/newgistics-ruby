module Newgistics
  class ShipmentUpdate
    include Virtus.model

    attribute :id, String
    attribute :order_id, String
    attribute :add_items, Array[Item], default: []
    attribute :remove_items, Array[Item], default: []
    attribute :success, Boolean

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def success?
      !!success
    end

    def save
      request = Requests::UpdateShipmentContents.new(self)
      response_handler = ResponseHandlers::UpdateShipmentContents.new(self)

      Newgistics.api.post(request, response_handler)

      errors.empty? && success?
    end
  end
end
