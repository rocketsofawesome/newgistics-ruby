module Newgistics
  class BogusItem
    include Virtus.model

    attribute :name, String
  end

  class BogusModel
    include Virtus.model

    attribute :id, String
    attribute :other_id, String
    attribute :simple_attribute, String
    attribute :bogus_items, Array[BogusItem]
    attribute :favorite_bogus_item, BogusItem
    attribute :custom_fields, Hash
    attribute :errors, Array[String]
    attribute :warnings, Array[String]
  end
end
