require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < Twitter::Error
      MESSAGE = "Server Error"

      # Create a new error from an HTTP environment
      #
      # @param body [Hash]
      # @return [Twitter::Error]
      def self.from_response(response={})
        new(nil, response[:response_headers])
      end

      # Initializes a new ServerError object
      #
      # @param message [String]
      # @return [Twitter::Error::ServerError]
      def initialize(message=nil, response_headers={})
        super((message || self.class.const_get(:MESSAGE)), response_headers)
      end

    end
  end
end
