module Newgistics
  class XmlMarshaller
    def assign_attributes(object, root)
      root.elements.each do |element|
        if element.elements.any?
          assign_nested_attribute(object, element)
        else
          assign_simple_attribute(object, element)
        end
      end
    end

    private

    def assign_nested_attribute(object, element)
      attribute = attribute_name(element)
      attribute_set = object.class.attribute_set[attribute]
      return if attribute_set.nil?

      if attribute_set.type.primitive == Array
        list_item_name = get_list_item_name(attribute_set)
        elements = element.css(list_item_name).map do |child|
          build_object(attribute_set.member_type.primitive, child)
        end
        object[attribute] = elements
      else
        new_object = build_object(attribute_set.type.primitive, element)
        object[attribute] = new_object
      end
    end

    def build_object(klass_name, element)
      klass_name.new.tap do |new_object|
        assign_attributes(new_object, element)
      end
    end

    def get_list_item_name(attribute_set)
      attribute_set.member_type.primitive.to_s.split('::').last
    end

    def assign_simple_attribute(object, element)
      attribute = attribute_name(element)
      if object.is_a?(Hash) || object.respond_to?(attribute)
        object[attribute] = element.text unless element.text.empty? 
      else
        puts "Object doesn't respond to #{attribute}"
      end
    end

    def attribute_name(element)
      StringHelper.underscore(element.name)
    end
  end
end
