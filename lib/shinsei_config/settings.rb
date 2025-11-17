# frozen_string_literal: true

module ShinseiConfig
  # Stores settings for RootConfig that are not part of the schema
  class Settings
    # @rbs @config_path: String?
    # @rbs @env: String?
    # @rbs @yaml_opts: Hash[Symbol, untyped]

    # @rbs attr_accessor config_path: String?
    # @rbs attr_accessor env: String?
    # @rbs attr_accessor yaml_opts: Hash[Symbol, untyped]
    attr_accessor :config_path, :env, :yaml_opts

    # @rbs return: void
    def initialize
      @config_path = nil
      @env = nil
      @yaml_opts = {}
    end

    # @rbs return: void
    def validate!
      raise Error, 'config_path is required' if config_path.nil? || config_path.empty?
    end
  end
end
