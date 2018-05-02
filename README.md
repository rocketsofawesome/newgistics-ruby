[![Code Climate](https://codeclimate.com/repos/5991e52637216b02640002d4/badges/9e19d346f6da0db0783c/gpa.svg)](https://codeclimate.com/repos/5991e52637216b02640002d4/feed)
[![Test Coverage](https://codeclimate.com/repos/5991e52637216b02640002d4/badges/9e19d346f6da0db0783c/coverage.svg)](https://codeclimate.com/repos/5991e52637216b02640002d4/coverage)
[ ![Codeship Status for rocketsofawesome/newgistics-ruby](https://app.codeship.com/projects/63cb9a70-68b6-0135-a28b-5ec5668067cc/status?branch=master)](https://app.codeship.com/projects/241459)
# Newgistics

This Ruby gem allows you to interact with the Newgistics Fulfillment API.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'newgistics', github: 'rocketsofawesome/newgistics-ruby'
```

And then execute:

    $ bundle

## Configuration
Here is a list of the available configuration options and their default values

| Option          | Description                                                                                                                                                                                                                                                | Default Value                                |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| `api_base_url`        | The URL of the Newgistics API                                                                                                                                                                                                                              | `"https://apistaging.newgisticsfulfillment.com"` |
| `api_key`         | Your Newgistics API key                                                                                                                                                                                                                                    | `nil`                                          |
| `time_zone`       | The time zone used by Newgistics. When the API sends timestamps back it doesn't include a time zone, if it's not provided, the value of this setting will be used when parsing the timestamps into `Time` objects. You shouldn't need to change this setting | `"America/Denver"`                               |
| `local_time_zone` | The time zone used by your application, all Newgistics timestamps will be translated to this time zone automatically.                                                                                                                                      | `"UTC"`                                         |

### Setting your configuration

To set configuration options use the `Newgistics.configure` method:

```ruby
Newgistics.configure do |config|
  config.api_key = ENV['NEWGISTICS_API_KEY']
  config.api_base_url = ENV['NEWGISTIC_API_URL']
  config.local_time_zone = "America/New_York"
end
```

When setting `time_zone` or `local_time_zone` pass a `String` with [the name of your time zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

If you're using this gem in a Rails app, you'll probably want to put this config in an initializer.

## Resources

### Orders

#### Placing an order on Newgistics

```ruby
order = Newgistics::Order.new(order_attributes)
order.save
```

`order_attributes` is a `Hash` containing all the attributes for the order, the attributes should map one-to-one to the Newgistics API spec.

`order.save` will return `true` if the order is placed successfully and `false` otherwise, any errors or warnings generated when placing the order are available under `order.errors` and `order.warnings` respectively

#### Updating a shipment's/order's contents on Newgistics
```ruby
shipment_update = Newgistics::ShipmentUpdate.new(id: SHIPMENT_ID)
shipment_update.add_items = [Newgistics::Item]
shipment_update.remove_items = [Newgistics::Item]
shipment_update.save
```

`add_items` and `remove_items` are arrays of `Newgistics::Item` that only require a `sku` and a `qty`. With these arrays we will update Newgistics what items to add and/or remove on the specified shipment_update object by either the shipment id(`id`) or you can use the internal order id(`order_id`) but BEWARE: use one or the other not both.

`shipment_update.save` will return `true` if the order is updated successfully and `false` otherwise, any errors or warnings generated when updating the shipment are available under `shipment_update.errors` and `shipment_update.warnings` respectively. `shipment_update.success` or also `shipment_update.success?` will also be updated to the corresponding value.

#### Cancelling a shipment/order on Newgistics
```ruby
shipment_cancellation = Newgistics::ShipmentCancellation.new(shipment_id: SHIPMENT_ID)
shipment_cancellation.save
```

You must either give a `shipment_id` or `order_id` when cancelling a shipment in order for Newgistics to find the appropriate shipment. There are also optional parameters of `cancel_if_in_process` and `cancel_if_backorder` which are boolean values and covered in the Newgistics API documentation.

`shipment_cancellation.save` will return `true` if the order is cancelled successfully and `false` otherwise, any errors or warnings generated when cancelling the shipment are available under `shipment_cancellation.errors` and `shipment_cancellation.warnings` respectively. `shipment_cancellation.success` or also `shipment_cancellation.success?` will also be updated to the corresponding value.

### Shipments

#### Searching for shipments on Newgistics

```ruby
Newgistics::Shipment.
  where(start_received_timestamp: start_date).
  where(end_received_timestamp: end_date).
  all
```

`start_date` and `end_date` are `Date` types in ISO 8601 format. Please note that when using timestamps the Newgistics API expects that you send both the `start_` timestamp and the `end_` timestamp. This means you cannot send `start_received_timestamp` without sending `end_received_timestamp` the same goes for `shipped_timestamp` and `exception_timestamp`.

You can use the `where` method to specify the parameters of the Search. Parameter keys will be automatically camelized when sent to Newgistics, for a full list of the available parameters refer to the Newgistics API documentation.

`Newgistics::Shipment.where(conditions).all` will return a list of `Newgistics::Shipment` elements if the request is successful. Otherwise it will raise a `Newgistics::QueryError`.

### Inbound Returns

#### Sending inbound returns to Newgistics
```ruby
Newgistics::InboundReturn.new(inbound_return_attributes).save
```

`inbound_return_attributes` is a `Hash` containing all the attributes for the inbound return, the attributes should map one-to-one to the Newgistics API spec. *Caveat*: you should only supply either `shipment_id` or `order_id` but not both because you will receive an error from the API.

`inbound_return.save` will return `true` if the inbound return is sent successfully to Newgistics and `false` otherwise, any errors or warnings generated when sending the inbound_return are available under `inbound_return.errors` and `inbound_return.warnings` respectively

#### Searching for inbound returns on Newgistics

```ruby
Newgistics::InboundReturn.
  where(start_created_timestamp: start_date).
  where(end_created_timestamp: end_date).
  all
```

You can use the `where` method to specify the parameters of the Search. Parameter keys will be automatically camelized when sent to Newgistics, for a full list of the available parameters refer to the Newgistics API documentation.

`Newgistics::InboundReturn.where(conditions).all` will return a list of `Newgistics::InboundReturn` elements if the request is successful. Otherwise it will raise a `Newgistics::QueryError`.

### Returns

#### Searching for returns received by Newgistics
```ruby
Newgistics::Return.
  where(start_timestamp: start_date).
  where(end_timestamp: end_date).
  all
```

`start_date` and `end_date` are Date types in ISO 8601 format. Please note that when using timestamps the Newgistics API expects that you send both the `start_timestamp` and the `end_timestamp.` This means you cannot send `start_timestamp` without sending `end_timestamp`.

You can use the where method to specify the parameters of the Search. Parameter keys will be automatically camelized when sent to Newgistics, for a full list of the available parameters refer to the Newgistics API documentation.

`Newgistics::Return.where(conditions).all` will return a list of `Newgistics::Return` elements if the request is successful. Otherwise it will raise a `Newgistics::QueryError`.

### Products

#### Retrieving products from Newgistics
```ruby
products = Newgistics::Product.all
products = Newgistics::Product.
  where(sku: sku).
  where(warehouse: warehouse_id).
  all
```
`sku` is a product's sku and `warehouse` is the warehouse's id number, where both of these values are strings. Parameter keys will be automatically camelized when sent to Newgistics, for a full list of the available parameters refer to the Newgistics API documentation.

However, parameters are not necessary for this endpoint and you will receive the complete inventory of products if you give it no parameters, so this allows you to just use the `all` method to retrieve the entire inventory.

`Newgistics::Product.all` will return a list of `Newgistics::Product` elements if the request is successful. Otherwise it will raise a `Newgistics::QueryError`.

### Inventory

#### Retrieve inventory details from Newgistics

```ruby
Newgistics::Inventory.
  where(start_timestamp: start_date, end_timestamp: end_date).
  all
```
`start_date` and `end_date` are Date types in ISO8601 format.

You can use the `where` method to specify the parameters for the Search. Parameter keys will be automatically camelized when sent to
Newgistics, for a full list of the available parameters refer to the Newgistics API documentation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rocketsofawesome/newgistics-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Newgistics project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/newgistics/blob/master/CODE_OF_CONDUCT.md).
