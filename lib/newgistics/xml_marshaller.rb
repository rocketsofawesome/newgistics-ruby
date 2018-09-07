module Newgistics
  class XmlMarshaller
    def assign_attributes(object, root)
      marshall_attributes(object, root)
      marshall_elements(object, root)
    end

    private

    def marshall_attributes(object, root)
      root.attributes.values.each do |attribute|
        transformed_name = attribute_name(attribute)
        assign_attribute(object, transformed_name, attribute.value)
      end
    end

    def marshall_elements(object, root)
      root.elements.each do |element|
        if element.elements.any?
          assign_nested_attribute(object, element)
        else
          assign_simple_attribute(object, element)
        end
      end
    end

    def assign_nested_attribute(object, element)
      attribute = attribute_name(element)
      attribute_set = object.class.attribute_set[attribute]
      return if attribute_set.nil?

      if attribute_set.type.primitive == Array
        object[attribute] = build_list(attribute_set.member_type.primitive, element)
      else
        object[attribute] = build_object(attribute_set.type.primitive, element)
      end
    end

    def build_list(item_class, element)
      element.css(item_class.element_selector).map do |child|
        build_object(item_class, child)
      end
    end

    def build_object(klass_name, element)
      klass_name.new.tap do |new_object|
        assign_attributes(new_object, element)
      end
    end

    def assign_simple_attribute(object, element)
      attribute = attribute_name(element)
      assign_attribute(object, attribute, element.text)
    end

    def assign_attribute(object, attribute, value)
      setter = "#{attribute}="
      if object.is_a?(Hash) || object.respond_to?(setter)
        object[attribute.to_sym] = value unless value.empty?
      end
    end

    def attribute_name(element)
      StringHelper.underscore(element.name)
    end
  end
end
