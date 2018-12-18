module Newgistics
  class PackageItem
    include Newgistics::Model

    attribute :sku, String
    attribute :qty, Integer

    def self.element_selector
      'item'
    end
  end
end
