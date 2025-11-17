# frozen_string_literal: true

module ShinseiConfig
  # Recursively builds Data.define objects from hash with deep freezing
  class ConfigBuilder
    # @rbs hash: Hash[untyped, untyped] -- return: Data
    def self.build(hash)
      new(hash).build
    end

    # @rbs @hash: Hash[untyped, untyped]

    # @rbs attr_reader hash: Hash[untyped, untyped]
    attr_reader :hash

    # @rbs hash: Hash[untyped, untyped] -- return: void
    def initialize(hash)
      @hash = hash
    end

    # @rbs return: Data
    def build
      raise Error, "Expected Hash, got #{hash.class}" unless hash.is_a?(Hash)

      # Create a Data.define class with all keys as symbols
      config_class = Data.define(*hash.keys.map(&:to_sym))

      # Build values, recursively converting nested hashes
      # Convert keys to symbols for Data.define
      values = hash.transform_keys(&:to_sym).transform_values { |v| build_value(v) }

      # Create instance and freeze
      config_class.new(**values).freeze
    end

    private

    # @rbs value: untyped -- return: untyped
    def build_value(value)
      case value
      when Hash
        ConfigBuilder.build(value)
      when Array
        value.map { |v| build_value(v) }.freeze
      else
        value
      end
    end
  end
end
