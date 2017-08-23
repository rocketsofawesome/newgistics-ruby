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
        object[attribute] = build_list(attribute_set.member_type.primitive, element)
      else
        object[attribute] = build_object(attribute_set.type.primitive, element)
      end
    end

    def build_list(item_class, element)
      item_selector = get_list_item_selector(item_class)
      element.css(item_selector).map do |child|
        build_object(item_class, child)
      end
    end

    def build_object(klass_name, element)
      klass_name.new.tap do |new_object|
        assign_attributes(new_object, element)
      end
    end

    def get_list_item_selector(item_class)
      item_class.to_s.split('::').last
    end

    def assign_simple_attribute(object, element)
      attribute = attribute_name(element)
      setter = "#{attribute}="
      if object.is_a?(Hash) || object.respond_to?(setter)
        object[attribute.to_sym] = element.text unless element.text.empty?
      end
    end

    def attribute_name(element)
      StringHelper.underscore(element.name)
    end
  end
end
