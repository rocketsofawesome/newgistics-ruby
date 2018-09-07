module Newgistics
  class CustomBogusItem
    include Newgistics::Model

    attribute :name, String

    def self.element_selector
      "Item"
    end
  end

  class BogusItem
    include Newgistics::Model

    attribute :name, String
  end

  class BogusModel
    include Newgistics::Model

    attribute :id, String
    attribute :other_id, String
    attribute :simple_attribute, String
    attribute :bogus_items, Array[BogusItem]
    attribute :custom_items, Array[CustomBogusItem]
    attribute :favorite_bogus_item, BogusItem
    attribute :custom_fields, Hash
    attribute :errors, Array[String]
    attribute :warnings, Array[String]
  end
end
