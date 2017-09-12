module Newgistics
  class Inventory
    include Virtus.model

    attribute :manifest_id, String
    attribute :manifest_po, String
    attribute :shipment_id, String
    attribute :order_id, String
    attribute :timestamp, Time
    attribute :sku, String
    attribute :quantity, Integer
    attribute :notes, String

    def self.where(conditions)
      Query.build(
        endpoint: '/inventory_details.aspx',
        element_selector: 'inventories inventory',
        model_class: self
      ).where(conditions)
    end
  end
end
