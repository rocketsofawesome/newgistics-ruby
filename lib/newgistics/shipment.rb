module Newgistics
  class Shipment
    include Virtus.model

    attribute :id, String
    attribute :client_name, String
    attribute :order_id, String
    attribute :purchase_order, String
    attribute :name, String
    attribute :last_name, String
    attribute :first_name, String
    attribute :company, String
    attribute :address1, String
    attribute :address2, String
    attribute :city, String
    attribute :state, String
    attribute :postal_code, String
    attribute :country, String
    attribute :email, String
    attribute :phone, String
    attribute :order_timestamp, DateTime
    attribute :received_timestamp, DateTime
    attribute :shipment_status, String
    attribute :order_type, String
    attribute :shipped_date, DateTime
    attribute :expected_delivery_date, DateTime
    attribute :delivered_timestamp, DateTime
    attribute :warehouse, Warehouse
    attribute :ship_method, String
    attribute :ship_method_code, String
    attribute :tracking, String
    attribute :items, Array[Item]
    attribute :custom_fields, Hash

    def self.where(conditions)
      Query.build(
        endpoint: '/shipments.aspx',
        element_selector: 'Shipments Shipment',
        model_class: self
      ).where(conditions)
    end
  end
end
