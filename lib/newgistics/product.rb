module Newgistics
  class Product
    include Virtus.model

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
      request = Requests::Search.new('/inventory.aspx')
      response_handler = ResponseHandlers::Search.new(
        element_selector: 'products product',
        model_class: self
      )

      Query.new(request, response_handler).where(conditions)
    end
  end
end
