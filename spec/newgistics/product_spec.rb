require 'spec_helper'

RSpec.describe Newgistics::Product do
  describe '.where' do
    context "when products return successfully" do
      it 'returns a list of products'
    end

    vcr_options = { cassette_name: 'inventory/where/failure' }
    context "when API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        Newgistics.configure { |c| c.api_key = 'INVALID' }
        query = Newgistics::Product.where(warehouse: "warehouse")

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end

  describe '.all' do
    context "when products return successfully" do
      it 'returns a list of products'
    end

    vcr_options = { cassette_name: 'inventory/all/failure' }
    context "when API returns an error", vcr: vcr_options do
      it 'raises a QueryError' do
        Newgistics.configure { |c| c.api_key = 'INVALID' }
        query = Newgistics::Product

        expect { query.all }.to raise_error(Newgistics::QueryError)
      end
    end
  end
end
