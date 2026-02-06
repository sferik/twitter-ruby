module Twitter
  module Streaming
    # Represents a Twitter streaming stall warning
    #
    # @api public
    class StallWarning < Twitter::Base
      # Returns the warning code
      #
      # @api public
      # @example
      #   stall_warning.code
      # @return [String]

      # Returns the warning message
      #
      # @api public
      # @example
      #   stall_warning.message
      # @return [String]

      # Returns the percent full value
      #
      # @api public
      # @example
      #   stall_warning.percent_full
      # @return [Integer]
      attr_reader :code, :message, :percent_full
    end
  end
end
