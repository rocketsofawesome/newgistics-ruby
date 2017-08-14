RSpec::Matchers.define :have_element do |path|
  match do |xml|
    @path = path
    @node = xml.at_css(path)

    match_node && match_text && match_attributes
  end

  chain :with_text do |text|
    @text = text
  end

  chain :with_attributes do |attributes|
    @attributes = attributes
  end

  failure_message do |xml|
    "expected #{xml} #{@failure_reason}"
  end

  def match_node
    return true if @node
    @failure_reason = "to contain a node at '#{@path}'"
    false
  end

  def match_text
    return true if @text.nil? || @node.text == @text
    @failure_reason = "at '#{@path}' to contain the text '#{@text}'"
    false
  end

  def match_attributes
    return true if @attributes.nil?

    @attributes.each do |key, value|
      if @node.send(:[], key) != value
        @failure_reason = "at '#{@path}' to have the attribute #{key} with value #{value}"
        return false
      end
    end
    true
  end
end
