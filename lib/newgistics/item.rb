module Newgistics
  class Item
    include Newgistics::Model

    attribute :id, String

    attribute :sku, String
    attribute :upc, String
    attribute :description, String
    attribute :lot, String
    attribute :qty, Integer
    attribute :is_gift_wrapped, Boolean
    attribute :custom_fields, Hash

    attribute :qty_returned, Integer
    attribute :return_reason, String
    attribute :qty_returned_to_stock, Integer
    attribute :return_timestamp, Timestamp

    attribute :reason, String
  end
end
