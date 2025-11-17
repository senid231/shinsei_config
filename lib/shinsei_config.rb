# frozen_string_literal: true

require_relative 'shinsei_config/version'

module ShinseiConfig
  class Error < StandardError; end
end

require_relative 'shinsei_config/settings'
require_relative 'shinsei_config/validation_error'
require_relative 'shinsei_config/loader'
require_relative 'shinsei_config/schema_validator'
require_relative 'shinsei_config/config_builder'
require_relative 'shinsei_config/root_config'
