module Newgistics
  class InboundReturn
    include Virtus.model

    attribute :id, String
    attribute :shipment_id, String
    attribute :order_id, String
    attribute :rma, String
    attribute :comments, String
    attribute :items, Array[Item]

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def self.where(conditions)
      Query.build(
        endpoint: '/inbound_returns.aspx',
        element_selector: 'InboundReturns InboundReturn',
        model_class: self
      ).where(conditions)
    end

    def save
      Requests::PostInboundReturn.new(self).perform

      errors.empty?
    end
  end
end
