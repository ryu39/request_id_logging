# RequestIdLogging

[![Gem Version](https://badge.fury.io/rb/request_id_logging.svg)](https://badge.fury.io/rb/request_id_logging)
[![Build Status](https://travis-ci.org/ryu39/request_id_logging.svg?branch=master)](https://travis-ci.org/ryu39/request_id_logging)
[![Code Climate](https://codeclimate.com/github/ryu39/request_id_logging/badges/gpa.svg)](https://codeclimate.com/github/ryu39/request_id_logging)
[![Test Coverage](https://codeclimate.com/github/ryu39/request_id_logging/badges/coverage.svg)](https://codeclimate.com/github/ryu39/request_id_logging/coverage)
[![Issue Count](https://codeclimate.com/github/ryu39/request_id_logging/badges/issue_count.svg)](https://codeclimate.com/github/ryu39/request_id_logging)

RequestIdLogging provides a Rack middleware and a logger formatter to prepend X-Request-Id to log messages in your Rails app.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'request_id_logging'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install request_id_logging


## Usage

First, add RequestIdLogging::Middleware to rack middlewares.
In your application.rb or environments/xxx.rb, insert RequestIdLogging::Middleware after ActionDispatch::RequestId.

```ruby
module MyApp
  class Application < Rails::Application
    # some configurations
    # :

    config.middleware.insert_after ActionDispatch::RequestId, RequestIdLogging::Middleware
  end
end
```

Next, set RequestIdLogging::Formatter instance to your logger's formatter.

```ruby
module MyApp
  class Application < Rails::Application
    # Set to Rails logger.
    config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
    config.logger.formatter = RequestIdLogging::Formatter.new
    config.logger.formatter.datetime_format = '%Y-%m-%d %H:%M:%S.%L '.freeze

    # And/Or set to your original logger's formatter.
    config.x.my_app_logger = Logger.new('log/my_app.log')
    config.x.my_app_logger.formatter = RequestIdLogging::Formatter.new
    config.x.my_app_logger.formatter.datetime_format = '%Y-%m-%d %H:%M:%S.%L '.freeze
  end
end
```

Then, loggers write logs with request id.

```ruby
Rails.logger.info 'test'
# => I, [2016-12-03 20:52:59.879 #106]  INFO -- : [aca576f4-f4fa-4c2a-b172-d8fb5cc37681] test

Rails.configuration.x.my_app_logger.info 'test my_app'
# => I, [2016-12-03 20:53:00.184 #106]  INFO -- : [aca576f4-f4fa-4c2a-b172-d8fb5cc37681] test my_app
```

### Request id customization

You can customize request id using `:request_id_proc` option.

Following example extracts first 8 characters from request id and uses it as request id.

```ruby
logger = Logger.new('log/my_app.log')
logger.formatter = RequestIdLogging::Formatter.new(request_id_proc: ->(id) { id&.first(8) }) # &. operator requires >= Ruby 2.3.0

logger.info 'customize request id'
# => I, [2016-12-03 20:46:31.399 #83]  INFO -- : [4a966ef6] customize request id
```

### Formatter delegation

You can use your original formatter using `:formatter` option.

If this option is specified, RequestIdLogging::Formatter prepends request id to `msg` and calls your formatter#call.

```ruby
original_formatter = Logger::Formatter.new
def original_formatter.call(severity, time, progname, msg)
  "MyFormatter: #{severity}, #{time}, #{progname}, #{msg}\n"
end

logger = Logger.new('log/my_app.log')
logger.formatter = RequestIdLogging::Formatter.new(formatter: original_formatter)

logger.info 'formatter delegation'
# => MyFormatter: INFO, 2016-12-04 10:47, , [6a8ef6bb-cf75-4ddf-a111-72c285c3ebda] test my_app
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/request_id_logging.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
