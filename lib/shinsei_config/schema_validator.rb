# frozen_string_literal: true

require 'dry-schema'

module ShinseiConfig
  # Wraps dry-schema for validating configuration
  class SchemaValidator
    attr_reader :schema

    def initialize(**options, &block)
      @schema = Dry::Schema.define(processor_type: Dry::Schema::JSON, **options, &block)
    end

    def validate!(config_hash)
      result = schema.call(config_hash)

      return if result.success?

      raise ValidationError, result.errors
    end
  end
end
