module Newgistics
  class ShipmentUpdate
    include Newgistics::Model

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
      Requests::UpdateShipmentContents.new(self).perform

      errors.empty? && success?
    end
  end
end
