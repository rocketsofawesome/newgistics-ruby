module Newgistics
  class UpdateShipment
    include Virtus.model

    attribute :id, String
    attribute :order_id, String
    attribute :add_items, Array[Item]
    attribute :remove_items, Array[Item]
    attribute :success, Boolean

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def success?
      !!success
    end

    def update
      request = Requests::UpdateShipmentContents.new(self)
      response_handler = ResponseHandlers::UpdateShipmentContents.new(self)

      Newgistics.api.post(request, response_handler)

      success || errors.empty?
    end
  end
end
