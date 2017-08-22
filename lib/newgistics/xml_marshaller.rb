module Newgistics
  class XmlMarshaller
    def assign_attributes(object, element)
      if element.elements.any?
        assign_nested_attribute(object, element)
      else
        assign_simple_attribute(object, element)
      end
    end

    private

    def assign_nested_attribute(object, element)
      attribute = attribute_name(element)
      setter = setter_name(element)
      attribute_set = object.class.attribute_set[attribute]
      return if attribute_set.nil? || !object.respond_to?(setter)

      if attribute_set.type.primitive.is_a? Array
        list_item_name = get_list_item_name(attribute_set)
        elements = element.at_css(list_item_name).map do |child|
          build_object(attribute_set.member_type.primitive, child)
        end
        object.send(setter, elements)
      else
        new_object = build_object(attribute_set.type.primitive.new, element)
        object.send(setter, new_object)
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
      setter = setter_name(element)
      if object.respond_to?(setter)
        object.send(setter, element.text)
      else
        puts "Object doesn't respond to #{setter}"
      end
    end

    def setter_name(element)
      "#{attribute_name(element)}="
    end

    def attribute_name(element)
      StringHelper.underscore(element.name)
    end
  end
end
