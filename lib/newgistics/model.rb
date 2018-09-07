module Newgistics
  module Model
    def self.included(base)
      base.include(Virtus.model)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def element_selector
        name.split('::').last
      end
    end
  end
end
