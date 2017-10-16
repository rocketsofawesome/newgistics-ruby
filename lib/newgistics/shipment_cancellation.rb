module Newgistics
  class ShipmentCancellation
    include Virtus.model

    attribute :shipment_id, String
    attribute :order_id, String
    attribute :cancel_if_in_process, Boolean
    attribute :cancel_if_backorder, Boolean
    attribute :success, Boolean

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def success?
      !!success
    end

    def save
      request = Requests::CancelShipment.new(self)
      response_handler = ResponseHandlers::CancelShipment.new(self)

      Newgistics.api.post(request, response_handler)

      errors.empty? && success?
    end
  end
end
