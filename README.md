# Weatherb

Weatherb comes from weather + rb (ruby file extension). It's basically a Ruby gem for retrieving data about weather using the [ClimaCell](https://www.climacell.co/) [API](https://www.climacell.co/weather-api/) in a simple way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weatherb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install weatherb

## Usage

To be able to use this gem, you need a ClimaCell account. [Sign in](https://developer.climacell.co/sign-in) to your ClimaCell account and visit the [dashboard](https://developer.climacell.co/dashboard/overview), there you'll find your API key.
```ruby
weatherb = Weatherb::API.new('this-is-your-api-key')

# Return a observational data at the present time
realtime = weatherb.realtime(lat: 40.784449, lon: -73.965208)

# Return a forecast data on a minute-by-minute basis
nowcast = weatherb.nowcast(lat: 40.784449, lon: -73.965208)

# Return a forecast data on an hourly basis
hourly = weatherb.hourly(lat: 40.784449, lon: -73.965208)

# Return a forecast data on  a daily basis
daily = weatherb.daily(lat: 40.784449, lon: -73.965208)
```
The example above uses the [default values](DEFAULT_VALUES.md), you can also add some additional parameters.
```ruby
# You can change the unit system into Royal (us), the default is Metric (si)
us_realtime = weatherb.realtime(lat: 40.784449, lon: -73.965208, unit_system: 'us')

# You can also specify the return field(s)
temp__humidity_hourly = weatherb.hourly(lat: 40.784449, lon: -73.965208, fields: ['temp', 'humidity'])

# And timestep for nowcast
ten_minutes_nowcast =  weatherb.nowcast(lat: 40.784449, lon: -73.965208, timestep: 10)

# Also start time and end time for nowcast, hourly, and daily API
next_time_daily = weatherb.daily(lat: 40.784449, lon: -73.965208, start_time: '2020-06-16T23:59:00', end_time: '2020-06-20T12:00:00')
```
Find out more about the ClimeCell API in [their documentation](https://developer.climacell.co/v3/reference).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zackijack/weatherb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/zackijack/weatherb/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Weatherb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/zackijack/weatherb/blob/master/CODE_OF_CONDUCT.md).
