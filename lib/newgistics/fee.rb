module Newgistics
  class Fee
    include Newgistics::Model

    attribute :type, String
    attribute :amount, Float
    attribute :notes, String
  end
end
