module Twitter
  module Streaming
    class Control

      # Initializes a new Control object
      #
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::Streaming::Control]
      def initialize(options = {})
        @control_uri = options[:control_uri]
      end
    end
  end
end
