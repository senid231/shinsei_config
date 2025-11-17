# frozen_string_literal: true

require 'yaml'
require 'erb'

module ShinseiConfig
  # Handles loading YAML files with ERB interpolation and environment splitting
  class Loader
    # @rbs @config_path: String
    # @rbs @env: String?
    # @rbs @yaml_opts: Hash[Symbol, untyped]

    # @rbs attr_reader config_path: String
    # @rbs attr_reader env: String?
    # @rbs attr_reader yaml_opts: Hash[Symbol, untyped]
    attr_reader :config_path, :env, :yaml_opts

    # @rbs config_path: String, env: String?, **yaml_opts: untyped -- return: void
    def initialize(config_path:, env: nil, **yaml_opts)
      @config_path = config_path
      @env = env
      @yaml_opts = yaml_opts
    end

    # @rbs return: Hash[String, untyped]
    def load
      raise Error, "Config file not found: #{config_path}" unless File.exist?(config_path)

      # Read raw content
      raw_content = File.read(config_path)

      # Process ERB on raw content before YAML parsing
      erb_processed = ERB.new(raw_content).result

      # Parse YAML with provided options
      parsed_yaml = YAML.safe_load(erb_processed, **yaml_opts)

      # Extract environment section if env is set
      extract_env_section(parsed_yaml)
    end

    private

    # @rbs parsed_yaml: Hash[String, untyped] -- return: Hash[String, untyped]
    def extract_env_section(parsed_yaml)
      return parsed_yaml unless env

      unless parsed_yaml.is_a?(Hash) && parsed_yaml.key?(env)
        raise Error, "Environment '#{env}' not found in config file"
      end

      parsed_yaml[env]
    end
  end
end
