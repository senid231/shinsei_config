# frozen_string_literal: true

module ShinseiConfig
  # Raised when config validation fails
  class ValidationError < Error
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super(format_errors)
    end

    private

    def format_errors
      return 'Validation failed' if errors.empty?

      formatted = errors.to_h.map do |key, messages|
        "  #{key}: #{messages.join(', ')}"
      end

      "Validation failed:\n#{formatted.join("\n")}"
    end
  end
end
