module Newgistics
  class Item
    include Virtus.model

    attribute :sku, String
    attribute :quantity, Integer
    attribute :is_gift_wrapped, Boolean
    attribute :custom_fields, Hash
  end
end
