module Newgistics
  class Warehouse
    include Virtus.model

    attribute :id, String

    attribute :name, String
    attribute :address, String
    attribute :city, String
    attribute :state, String
    attribute :postal_code, String
    attribute :country, String
  end
end
