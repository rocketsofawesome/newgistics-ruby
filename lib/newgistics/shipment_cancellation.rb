module Newgistics
  class ShipmentCancellation
    include Newgistics::Model

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
      Requests::CancelShipment.new(self).perform

      errors.empty? && success?
    end
  end
end
