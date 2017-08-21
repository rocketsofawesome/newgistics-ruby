[![Code Climate](https://codeclimate.com/repos/5991e52637216b02640002d4/badges/9e19d346f6da0db0783c/gpa.svg)](https://codeclimate.com/repos/5991e52637216b02640002d4/feed)
[![Test Coverage](https://codeclimate.com/repos/5991e52637216b02640002d4/badges/9e19d346f6da0db0783c/coverage.svg)](https://codeclimate.com/repos/5991e52637216b02640002d4/coverage)
[ ![Codeship Status for rocketsofawesome/newgistics-ruby](https://app.codeship.com/projects/63cb9a70-68b6-0135-a28b-5ec5668067cc/status?branch=master)](https://app.codeship.com/projects/241459)\
# Newgistics

This Ruby gem allows you to interact with the Newgistics Fulfillment API.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'newgistics', github: 'rocketsofawesome/newgistics-ruby'
```

And then execute:

    $ bundle

## Resources

### Orders

#### Placing an order on Newgistics

```ruby
order = Newgistics::Order.new(order_attributes)
order.save
```

`order_attributes` is a `Hash` containing all the attributes for the order, the attributes should map one-to-one to the Newgistics API spec.

`order.save` will return `true` if the order is placed successfully and `false` otherwise, any errors or warnings generated when placing the order are available under `order.errors` and `order.warnings` respectively


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/newgistics. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Newgistics project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/newgistics/blob/master/CODE_OF_CONDUCT.md).
