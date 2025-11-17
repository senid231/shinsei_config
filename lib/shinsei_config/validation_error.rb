# frozen_string_literal: true

module ShinseiConfig
  # Raised when config validation fails
  class ValidationError < Error
    # @rbs @errors: Hash[Symbol, Array[String]]

    # @rbs attr_reader errors: Hash[Symbol, Array[String]]
    attr_reader :errors

    # @rbs errors: Hash[Symbol, Array[String]] -- return: void
    def initialize(errors)
      @errors = errors
      super(format_errors)
    end

    private

    # @rbs return: String
    def format_errors
      return 'Validation failed' if errors.empty?

      formatted = errors.to_h.map do |key, messages|
        "  #{key}: #{messages.join(', ')}"
      end

      "Validation failed:\n#{formatted.join("\n")}"
    end
  end
end
