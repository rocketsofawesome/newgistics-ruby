module Newgistics
  class ManifestItem
    include Newgistics::Model

    attribute :damaged_qty, Integer
    attribute :description, String
    attribute :original_qty, Integer
    attribute :received_qty, Integer
    attribute :sku, String
    attribute :upc, String
    attribute :variance, Integer

    def self.element_selector
      "item"
    end
  end
end
