module Newgistics
  class Package
    include Newgistics::Model

    attribute :tracking_number, String
    attribute :weight, Float
    attribute :billable_weight, Float
    attribute :height, Float
    attribute :width, Float
    attribute :depth, Float
    attribute :items, Array[Item]
  end
end
