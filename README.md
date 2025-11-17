# ShinseiConfig

Shinsei (真正 — "genuine, correct, authentic")

A Ruby gem for loading configuration from YAML files with schema validation, ERB interpolation, and environment-specific settings.

## Features

- **Schema Validation**: Uses [dry-schema](https://dry-rb.org/gems/dry-schema/) for robust configuration validation
- **ERB Interpolation**: Process ERB templates before YAML parsing
- **Environment Splitting**: Load environment-specific configurations
- **Immutable Config Objects**: Uses Ruby 3.2+ `Data.define` for frozen, immutable configuration objects
- **Type-Safe Access**: Access configuration values with dot notation
- **Custom YAML Options**: Pass custom options to YAML parser

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add shinsei_config
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install shinsei_config
```

## Usage

### Basic Example

```ruby
require 'shinsei_config'

class MyAppConfig < ShinseiConfig::RootConfig
  settings do |s|
    s.config_path = Rails.root.join('config/my_app_config.yml').to_s # required
    s.env = Rails.env.to_s # optional, default nil which means no env splitting
    s.yaml_opts = { aliases: true } # optional, default {}
  end

  schema do
    required(:write_account_stats).value(:bool?)
    required(:api_keys).hash do
      required(:service_a).filled(:string)
      required(:service_b).filled(:string)
    end
  end

  def self.service_a_test?
    # custom methods to access config values
    api_keys.service_a.start_with?('test-')
  end
end

# When application starts
MyAppConfig.load! # may raise ShinseiConfig::ValidationError if config is invalid

# Somewhere in the app
MyAppConfig.api_keys.service_a # => "actual-key"
MyAppConfig.write_account_stats # => true
MyAppConfig.service_a_test? # => false
```

### YAML File Examples

#### Simple Configuration (config/my_app_config.yml)

```yaml
write_account_stats: true
api_keys:
  service_a: <%= ENV['SERVICE_A_KEY'] %>
  service_b: production-key-b
```

#### Environment-Specific Configuration

```yaml
development:
  write_account_stats: false
  api_keys:
    service_a: test-key-a
    service_b: test-key-b

production:
  write_account_stats: true
  api_keys:
    service_a: <%= ENV['SERVICE_A_KEY'] %>
    service_b: <%= ENV['SERVICE_B_KEY'] %>
```

### Features in Detail

#### ERB Interpolation

ERB is processed on the raw YAML content before parsing:

```yaml
# config.yml
database_url: <%= ENV.fetch('DATABASE_URL', 'postgres://localhost/mydb') %>
max_connections: <%= 2 * 5 %>
```

#### Schema Validation

The gem uses [dry-schema](https://dry-rb.org/gems/dry-schema/) for validation:

```ruby
schema do
  required(:database).hash do
    required(:host).filled(:string)
    required(:port).filled(:integer)
  end

  optional(:features).array(:string)

  required(:timeout).value(:integer, gt?: 0)
end
```

#### Custom YAML Options

Pass custom options to the YAML parser:

```ruby
settings do |s|
  s.config_path = 'config/app.yml'
  s.yaml_opts = {
    aliases: true,
    permitted_classes: [Date, Time],
    permitted_symbols: []
  }
end
```

#### Immutable Configuration

All configuration objects are deeply frozen and immutable:

```ruby
MyAppConfig.api_keys.frozen? # => true
MyAppConfig.api_keys.service_a.frozen? # => true
```

#### Reloading Configuration

You can reload the configuration at runtime (useful for development):

```ruby
MyAppConfig.reload!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/senid231/shinsei_config.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
