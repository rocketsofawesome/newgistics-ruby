require 'spec_helper'

RSpec.describe Newgistics::PackageItem do
  describe '.element_selector' do
    it "returns item" do
      expect(described_class.element_selector).to eq('item')
    end
  end
end
