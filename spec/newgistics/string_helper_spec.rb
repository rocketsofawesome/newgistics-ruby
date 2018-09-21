require 'spec_helper'

RSpec.describe Newgistics::StringHelper do
  describe '.camelize' do
    context "when upcase_first is true" do
      it "transforms an underscored string as expected" do
        result = described_class.camelize('a_sample_string', upcase_first: true)

        expect(result).to eq('ASampleString')
      end

      it "transforms a mixed string as expected" do
        result = described_class.camelize('a_Sample_String', upcase_first: true)

        expect(result).to eq('ASampleString')
      end
    end

    context "when upcase_first is false" do
      it "transforms an underscored string as expected" do
        result = described_class.camelize('a_sample_string', upcase_first: false)

        expect(result).to eq('aSampleString')
      end

      it "transforms a mixed string as expected" do
        result = described_class.camelize('A_Sample_String', upcase_first: false)

        expect(result).to eq('aSampleString')
      end
    end
  end

  describe '.underscore' do
    it "transforms a camel-cased string properly" do
      expect(described_class.underscore('aNiceString')).to eq('a_nice_string')
    end
  end
end
