module Newgistics
  class Item
    include Virtus.model

    attribute :id, String
    
    attribute :sku, String
    attribute :qty, Integer
    attribute :is_gift_wrapped, Boolean
    attribute :custom_fields, Hash

    attribute :qty_returned, Integer
    attribute :return_reason, String
    attribute :qty_returned_to_stock, Integer
    attribute :return_timestamp, DateTime

    attribute :reason, String
  end
end
