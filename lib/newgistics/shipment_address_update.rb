module Newgistics
  class ShipmentAddressUpdate
    include Newgistics::Model

    attribute :id, String
    attribute :order_id, String

    attribute :company, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :address1, String
    attribute :address2, String
    attribute :city, String
    attribute :state, String
    attribute :postal_code, String
    attribute :country, String
    attribute :email, String
    attribute :phone, String
    attribute :fax, String
    attribute :is_residential, Boolean

    attribute :status, String
    attribute :status_notes, String
    attribute :ship_method, String

    attribute :success, Boolean
    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def success?
      !!success
    end

    def save
      Requests::UpdateShipmentAddress.new(self).perform
      errors.empty? && success?
    end
  end
end
