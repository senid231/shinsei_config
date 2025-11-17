# frozen_string_literal: true

module ShinseiConfig
  # Recursively builds Data.define objects from hash with deep freezing
  class ConfigBuilder
    def self.build(hash)
      new(hash).build
    end

    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

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
