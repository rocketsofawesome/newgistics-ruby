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
    attribute :order_timestamp, Timestamp
    attribute :received_timestamp, Timestamp
    attribute :shipment_status, String
    attribute :order_type, String
    attribute :shipped_date, Timestamp
    attribute :expected_delivery_date, Timestamp
    attribute :delivered_timestamp, Timestamp
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
