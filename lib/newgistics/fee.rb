module Newgistics
  class Fee
    include Virtus.model

    attribute :type, String
    attribute :amount, Float
    attribute :notes, String
  end
end
