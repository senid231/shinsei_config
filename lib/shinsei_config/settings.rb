# frozen_string_literal: true

module ShinseiConfig
  # Stores settings for RootConfig that are not part of the schema
  class Settings
    attr_accessor :config_path, :env, :yaml_opts

    def initialize
      @config_path = nil
      @env = nil
      @yaml_opts = {}
    end

    def validate!
      raise Error, 'config_path is required' if config_path.nil? || config_path.empty?
    end
  end
end
