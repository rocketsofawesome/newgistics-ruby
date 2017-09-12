module Newgistics
  class Return
    include Virtus.model

    attribute :warehouse_id, String
    attribute :shipment_id, String
    attribute :order_id, String

    attribute :status, String
    attribute :name, String
    attribute :company, String
    attribute :address1, String
    attribute :address2, String
    attribute :city, String
    attribute :state, String
    attribute :postal_code, String
    attribute :country, String
    attribute :email, String
    attribute :phone, String
    attribute :carrier, String
    attribute :tracking_number, String
    attribute :postage_due, Float
    attribute :rma_present, Boolean
    attribute :rma_number, String
    attribute :reason, String
    attribute :condition, String
    attribute :notes, String
    attribute :is_archived, Boolean
    attribute :timestamp, Time
    attribute :items, Array[Item]

    def self.where(conditions)
      Query.build(
        endpoint: '/returns.aspx',
        element_selector: 'Returns Return',
        model_class: self
      ).where(conditions)
    end
  end
end
