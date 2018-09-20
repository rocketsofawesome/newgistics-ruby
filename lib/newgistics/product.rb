module Newgistics
  class Product
    include Newgistics::Model

    attribute :id, String
    attribute :sku, String

    attribute :putaway_quantity, Integer
    attribute :quarantine_quantity, Integer
    attribute :damaged_quantity, Integer
    attribute :expired_quantity, Integer
    attribute :recalled_quantity, Integer
    attribute :current_quantity, Integer
    attribute :kitting_quantity, Integer
    attribute :pending_quantity, Integer
    attribute :available_quantity, Integer

    def self.all
      where({}).all
    end

    def self.where(conditions)
      Query.build(
        endpoint: '/inventory.aspx',
        model_class: self
      ).where(conditions)
    end

    def self.element_selector
      'product'
    end
  end
end
