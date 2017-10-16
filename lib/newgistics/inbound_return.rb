module Newgistics
  class InboundReturn
    include Virtus.model

    attribute :id, String
    attribute :shipment_id, String
    attribute :order_id, String
    attribute :rma, String
    attribute :comments, String
    attribute :items, Array[Item]

    attribute :errors, Array[String]
    attribute :warnings, Array[String]

    def save
      request = Requests::PostInboundReturn.new(self).perform

      errors.empty?
    end
  end
end
