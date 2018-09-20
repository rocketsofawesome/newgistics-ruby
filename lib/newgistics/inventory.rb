module Newgistics
  class Inventory
    include Newgistics::Model

    attribute :manifest_id, String
    attribute :manifest_po, String
    attribute :shipment_id, String
    attribute :order_id, String
    attribute :timestamp, Timestamp
    attribute :sku, String
    attribute :quantity, Integer
    attribute :notes, String

    def self.where(conditions)
      Query.build(
        endpoint: '/inventory_details.aspx',
        model_class: self
      ).where(conditions)
    end

    def self.element_selector
      'inventory'
    end
  end
end
