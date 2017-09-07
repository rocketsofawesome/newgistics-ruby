require 'spec_helper'

RSpec.describe Newgistics::Product do
  include IntegrationHelpers

  describe '.where' do
    vcr_options = { cassette_name: 'product/where/success' }
    context "when the API doesn't return errors", vcr: vcr_options do
      it 'returns a list of products' do
        use_valid_api_key
        query = described_class.where(sku: '2010-025-E')

        products = query.all

        expect(products.first).to have_attributes(
          id: '1484567',
          sku: '2010-025-E',
          putaway_quantity: 0,
          quarantine_quantity: 0,
          damaged_quantity: 0,
          expired_quantity: 0,
          recalled_quantity: 0,
          current_quantity: 0,
          kitting_quantity: 0,
          pending_quantity: 0,
          available_quantity: 0
        )
      end
    end

    vcr_options = { cassette_name: 'product/where/failure' }
    context "when API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        use_invalid_api_key
        query = Newgistics::Product.where(warehouse: "warehouse")

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end

  describe '.all' do
    vcr_options = { cassette_name: 'product/all/success' }
    context "when the API returns no errors", vcr: vcr_options do
      it 'returns a list of products' do
        use_valid_api_key
        products = described_class.all

        expect(products.size).to eq(10)
        expect(products.first).to have_attributes(
          id: '1484565',
          sku: '1007-201-G',
          putaway_quantity: 0,
          quarantine_quantity: 0,
          damaged_quantity: 0,
          expired_quantity: 0,
          recalled_quantity: 0,
          current_quantity: 0,
          kitting_quantity: 0,
          pending_quantity: 1,
          available_quantity: -1
        )
      end
    end

    vcr_options = { cassette_name: 'product/all/failure' }
    context "when API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        use_invalid_api_key
        query = Newgistics::Product

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end
end
