require 'spec_helper'

RSpec.describe Newgistics::ResponseHandlers::SearchShipments do
  include FaradayHelpers

  describe '#handle' do
    context "when the response has a successful HTTP status" do
      it "raises a Newgistics::QueryError when there are errors in the body" do
        response_body = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8" ?>
          <response>
              <errors><error>Incorrect skus</error></errors>
          </response>
        HEREDOC
        response = build_response(status: 200, body: response_body)
        response_handler = described_class.new

        expect { response_handler.handle(response) }.
          to raise_error(Newgistics::QueryError)
      end

      it "returns an array of shipments when passed a proper Shipment" do
        xml = <<-XML
        <Shipment id="91755249">
          <ClientName>Rockets of Awesome</ClientName>
          <OrderID>XML001</OrderID>
          <PurchaseOrder/>
          <Name>STEPHEN STRANGE</Name>
          <FirstName>STEPHEN</FirstName>
          <LastName>STRANGE</LastName>
          <Company/>
          <Address1>75 SPRING ST FL 4</Address1>
          <Address2/>
          <City>NEW YORK</City>
          <State>NY</State>
          <PostalCode>10012-4096</PostalCode>
          <Country>UNITED STATES</Country>
          <Email>stephen@strange.com</Email>
          <Phone>617 123 4567</Phone>
          <OrderTimestamp>2017-08-20T00:00:00</OrderTimestamp>
          <ReceivedTimestamp>2017-08-21T07:22:03.413</ReceivedTimestamp>
          <ShipmentStatus>ONHOLD</ShipmentStatus>
          <OrderType>Consumer</OrderType>
          <ShippedDate/>
          <ExpectedDeliveryDate/>
          <DeliveredTimestamp/>
          <DeliveryException/>
          <Warehouse id="157">
            <Name>Hebron, KY</Name>
            <Address>1200 WORLDWIDE BLVD</Address>
            <City>HEBRON</City>
            <State>KY</State>
            <PostalCode>41048</PostalCode>
            <Country>US</Country>
          </Warehouse>
          <ShipMethod>Hold, Do  Not Ship</ShipMethod>
          <ShipMethodCode>HOLD</ShipMethodCode>
          <Tracking/>
          <TrackingUrl/>
          <Weight/>
          <Postage/>
          <GiftWrap>false</GiftWrap>
          <CustomFields>
            <AdditionalTax>15.0</AdditionalTax>
            <Subtotal>10.0</Subtotal>
            <Total>25.0</Total>
          </CustomFields>
          <BackorderedItems/>
          <Items>
            <Item>
              <Qty>1</Qty>
              <SKU>ABC-123</SKU>
            </Item>
          </Items>
          <Packages/>
        </Shipment>
        XML
        xml = Nokogiri::XML(xml)
        object = Newgistics::Shipment.new
        Newgistics::XmlMarshaller.new.assign_attributes(object, xml.root)

        expect(object).to have_attributes(
          :order_id => "XML001",
          :name => "STEPHEN STRANGE",
          :first_name => "STEPHEN",
          :last_name => "STRANGE",
          :address1 => "75 SPRING ST FL 4",
          :city => "NEW YORK",
          :state => "NY",
          :postal_code => "10012-4096",
          :country => "UNITED STATES",
          :email => "stephen@strange.com",
          :phone => "617 123 4567",
          :order_timestamp => DateTime.parse("2017-08-20T00:00:00"),
          :received_timestamp => DateTime.parse("2017-08-21T07:22:03.413"),
          :shipment_status => "ONHOLD",
          :order_type => "Consumer",
          :shipment_date => nil,
          :expected_delivery_date => nil,
          :delivered_timestamp => nil,
          :ship_method => "Hold, Do  Not Ship",
          :ship_method_code =>"HOLD",
          :tracking => nil
          )

        expect(object.warehouse).to have_attributes(
          :name => "Hebron, KY",
          :address => "1200 WORLDWIDE BLVD",
          :city => "HEBRON",
          :state => "KY",
          :postal_code => "41048",
          :country => "US"
          )

        expect(object.items.length).to eql 1
        item = object.items.first
        expect(item.qty).to eql 1
        expect(item.sku).to eql "ABC-123"

        expect(object.custom_fields).to include(
          "additional_tax" => "15.0",
          "subtotal" => "10.0",
          "total" => "25.0"
          )
      end
    end

    context "when the response has a failure HTTP status" do
      it "raises a Newgistics::QueryError" do
        response = build_response(status: 404, reason_phrase: 'Not Found')
        response_handler = described_class.new

        expect { response_handler.handle(response) }.
          to raise_error(Newgistics::QueryError)
      end
    end
  end
end
