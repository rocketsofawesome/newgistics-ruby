module Newgistics
  class Customer
    include Newgistics::Model

    attribute :company, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :email, String

    attribute :address1, String
    attribute :address2, String
    attribute :city, String
    attribute :state, String
    attribute :country, String
    attribute :phone, String
    attribute :fax, String
    attribute :zip, String
    attribute :is_residential, Boolean
  end
end
