require 'spec_helper'

RSpec.describe Newgistics::Query do
  describe '#where' do
    it "returns the query so we can chain methods" do
      query = build_query

      result = query.where(attribute: 'value')

      expect(result).to eq(query)
    end

    it "adds the conditions to the query" do
      query = build_query

      query.where(attribute: 'value')

      expect(query.conditions).to eq(attribute: 'value')
    end
  end

  describe '#all' do
    it "returns the results of the query" do
      request = Newgistics::BogusRequest.new
      response_handler = Newgistics::BogusResponseHandler.new
      query = build_query(request: request, response_handler: response_handler)
      stub_results(request, response_handler, [1, 2, 3])

      expect(query.all).to eq([1, 2, 3])
    end
  end

  describe '#each' do
    it "yields the results of the query" do
      request = Newgistics::BogusRequest.new
      response_handler = Newgistics::BogusResponseHandler.new
      query = build_query(request: request, response_handler: response_handler)
      stub_results(request, response_handler, [1, 2, 3])

      expect { |b| query.each(&b) }.to yield_successive_args(1, 2, 3)
    end
  end

  def stub_results(request, response, results)
    allow(Newgistics.api).to receive(:get).with(request, response).
      and_return(results)
  end

  def build_query(request: nil, response_handler: nil)
    described_class.new(request, response_handler)
  end
end
