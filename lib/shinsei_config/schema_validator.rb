# frozen_string_literal: true

require 'dry-schema'

module ShinseiConfig
  # Wraps dry-schema for validating configuration
  class SchemaValidator
    # @rbs @schema: Dry::Schema::Processor

    # @rbs attr_reader schema: Dry::Schema::Processor
    attr_reader :schema

    # @rbs **opts: untyped -- return: void
    def initialize(**, &)
      @schema = Dry::Schema.define(processor_type: Dry::Schema::JSON, **, &)
    end

    # @rbs config_hash: Hash[untyped, untyped] -- return: void
    def validate!(config_hash)
      result = schema.call(config_hash)

      return if result.success?

      raise ValidationError, result.errors
    end
  end
end
