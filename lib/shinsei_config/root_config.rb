# frozen_string_literal: true

module ShinseiConfig
  # Base class for configuration. Users inherit from this class.
  class RootConfig
    class << self
      # @rbs @settings: Settings?
      # @rbs @schema_validator: SchemaValidator?
      # @rbs @config: Data?

      # Configure settings for this config class
      # @rbs () { (Settings) -> void } -> Settings
      def settings(&block)
        @settings ||= Settings.new
        block&.call(@settings)
        @settings
      end

      # Define validation schema
      # @rbs () { () -> void } -> SchemaValidator?
      def schema(&block)
        @schema_validator = SchemaValidator.new(&block) if block
        @schema_validator
      end

      # Load and validate configuration
      # @rbs return: singleton(RootConfig)
      def load!
        validate_setup!

        # Load YAML with ERB and env splitting
        loader = Loader.new(
          config_path: settings.config_path,
          env: settings.env,
          **settings.yaml_opts
        )
        config_hash = loader.load

        # Validate against schema if defined
        schema&.validate!(config_hash)

        # Build config object
        @config = ConfigBuilder.build(config_hash)

        self
      end

      # Reload configuration
      # @rbs return: singleton(RootConfig)
      def reload!
        @config = nil
        load!
      end

      # Access config instance
      # @rbs return: Data
      def config
        raise Error, "Config not loaded. Call #{name}.load! first" unless @config

        @config
      end

      # Delegate method calls to config instance
      # @rbs method_name: Symbol, *args: untyped, **kwargs: untyped -- return: untyped
      def method_missing(method_name, *, &)
        if config.respond_to?(method_name)
          config.public_send(method_name, *, &)
        else
          super
        end
      end

      # @rbs method_name: Symbol, include_private: bool -- return: bool
      def respond_to_missing?(method_name, include_private = false)
        config.respond_to?(method_name) || super
      end

      private

      # @rbs return: void
      def validate_setup!
        settings.validate!

        return if schema

        raise Error, "Schema not defined. Call #{name}.schema { ... } in class body"
      end
    end
  end
end
