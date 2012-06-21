require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < Twitter::Error
      MESSAGE = "Server Error"

      # Create a new error from an HTTP environment
      #
      # @param env [Hash]
      # @return [Twitter::Error]
      def self.from_env(env)
        new(nil, env[:response_headers])
      end

      # Initializes a new ServerError object
      #
      # @param message [String]
      # @param http_headers [Hash]
      # @return [Twitter::Error::ServerError]
      def initialize(message=nil, http_headers={})
        message ||= self.class.const_get(:MESSAGE)
        super(message, http_headers)
      end

    end
  end
end
