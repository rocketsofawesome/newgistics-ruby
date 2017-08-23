module Newgistics
  class Product
    include Virtus.model

    attribute :id, String
    attribute :sku, String

    attribute :put_away_quantity, Integer
    attribute :quarantine_quantity, Integer
    attribute :damaged_quantity, Integer
    attribute :expired_quantity, Integer
    attribute :recalled_quantity, Integer
    attribute :current_quantity, Integer
    attribute :kitting_quantity, Integer
    attribute :pending_quantity, Integer
    attribute :available_quantity, Integer

    def self.all
      request = Requests::Inventory.new
      response_handler = ResponseHandlers::Inventory.new

      Query.new(request, response_handler).all
    end

    def self.where(conditions)
      request = Requests::Inventory.new
      response_handler = ResponseHandlers::Inventory.new

      Query.new(request, response_handler).where(conditions)
    end
  end
end
