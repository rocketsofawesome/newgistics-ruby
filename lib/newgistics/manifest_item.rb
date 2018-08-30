module Newgistics
  class ManifestItem
    include Virtus.model

    attribute :sku, String
    attribute :description, String
    attribute :original_qty, Integer
    attribute :received_qty, Integer
  end
end
