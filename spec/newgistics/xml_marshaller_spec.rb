require 'spec_helper'

RSpec.describe Newgistics::XmlMarshaller do
  describe '#assign_attributes' do
    it "assigns simple attributes" do
      xml = build_xml(<<-XML)
        <BogusModel>
          <SimpleAttribute>Simple Value</SimpleAttribute>
        </BogusModel>
      XML
      marshaller = described_class.new
      object = Newgistics::BogusModel.new

      marshaller.assign_attributes(object, xml.root)

      expect(object.simple_attribute).to eq('Simple Value')
    end

    it "handles attributes that don't exist in the object" do
      xml = build_xml(<<-XML)
        <BogusModel>
          <MissingAttribute>Simple Value</MissingAttribute>
        </BogusModel>
      XML
      marshaller = described_class.new
      object = Newgistics::BogusModel.new

      expect { marshaller.assign_attributes(object, xml.root) }.
        not_to raise_error
    end

    it "assigns lists" do
      xml = build_xml(<<-XML)
        <BogusModel>
          <BogusItems>
            <BogusItem>
              <Name>First item</Name>
            </BogusItem>
            <BogusItem>
              <Name>Second item</Name>
            </BogusItem>
          </BogusItems>
        </BogusModel>
      XML
      marshaller = described_class.new
      object = Newgistics::BogusModel.new

      marshaller.assign_attributes(object, xml.root)

      item_names = object.bogus_items.map(&:name)
      expect(item_names).to eq ['First item', 'Second item']
    end

    it "assigns hash attributes" do
      xml = build_xml(<<-XML)
        <BogusModel>
          <CustomFields>
            <Subtotal>8.0</Subtotal>
            <AdditionalTax>2.0</AdditionalTax>
            <Total>10.0</Total>
          </CustomFields>
        </BogusModel>
      XML
      marshaller = described_class.new
      object = Newgistics::BogusModel.new

      marshaller.assign_attributes(object, xml.root)

      expect(object.custom_fields).to eq(
        subtotal: "8.0",
        additional_tax: "2.0",
        total: "10.0"
      )
    end

    it "assigns custom object attributes" do
      xml = build_xml(<<-XML)
        <BogusModel>
          <FavoriteBogusItem>
            <Name>My favorite item!</Name>
          </FavoriteBogusItem>
        </BogusModel>
      XML
      marshaller = described_class.new
      object = Newgistics::BogusModel.new

      marshaller.assign_attributes(object, xml.root)

      expect(object.favorite_bogus_item.name).to eq('My favorite item!')
    end
  end

  def build_xml(string)
    Nokogiri::XML(string)
  end
end
