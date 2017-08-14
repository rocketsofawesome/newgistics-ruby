require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::PostShipment do
  describe '#handle' do
    order = Newgistics::Order.new(
        warehouse_id: 'WAREHOUSE_ID',
        ship_method: 'USPS',
        info_line: 'Additional order details',
        requires_signature: false,
        is_insured: false,
        add_gift_wrap: false,
        hold_for_all_inventory: true,
        order_date: '2017-08-20',
        customer: {
          first_name: 'Stephen',
          last_name: 'Strange',
          address1: '75 Spring St',
          address2: '4th Floor',
          city: 'New York',
          state: 'NY',
          zip: '10012',
          country: 'USA',
          email: 'stephen@strange.com',
          phone: '617 123 4567',
          is_residential: false
        },
        custom_fields: {
          subtotal: 10.0,
          additional_tax: 15.0,
          total: 25.0
        },
        items: [
          { sku: 'SKU1', quantity: 1, is_gift_wrapped: false },
          {
            sku: 'SKU2',
            quantity: 2,
            is_gift_wrapped: true,
            custom_fields: {
              gift_message: 'A sample message'
            }
          }
        ]
      )
    it 'handles a successful response with no errors' do
      expected_body = <<~HEREDOC
      <?xml version="1.0" encoding="UTF-8" ?>
        <response>
            <shipments>
                <shipment id="6013782" orderID="XML001" />
            </shipments>
            <warnings></warnings>
            <errors></errors>
        </response>
      HEREDOC
      stub_request(:post, "http://newgistics.com/post_shipments.aspx").
        with(query: hash_including({})).
        to_return(status: 200, body: expected_body, headers: {})
      response_handler = described_class.new(order)
      uri = URI.parse('http://newgistics.com/post_shipments.aspx')
      req = Net::HTTP::Post.new(uri.path)
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      response_handler.handle(response)
      expect(order.errors).to be_empty
      expect(order.warnings).to be_empty
      expect(order.shipment_id).to eq "6013782"
    end

    it 'handles an unsuccessful response with errors' do
      expected_body = <<~HEREDOC
      <?xml version="1.0" encoding="UTF-8" ?>
        <response>
            <shipments>
                <shipment id="6013782" orderID="XML001" />
            </shipments>
            <warnings><warning>The order did not go through</warning></warnings>
            <errors><error>Incorrect skus</error></errors>
        </response>
      HEREDOC
      stub_request(:post, "http://newgistics.com/post_shipments.aspx").
        with(query: hash_including({})).
        to_return(status: 200, body: expected_body, headers: {})
      response_handler = described_class.new(order)
      uri = URI.parse('http://newgistics.com/post_shipments.aspx')
      req = Net::HTTP::Post.new(uri.path)
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      response_handler.handle(response)
      expect(order.errors.length).to eq 1
      expect(order.warnings.length).to eq 1
      expect(order.errors.first).to eq "Incorrect skus"
      expect(order.warnings.first).to eq "The order did not go through"
    end
  end
end