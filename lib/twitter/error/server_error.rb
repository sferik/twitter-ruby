require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < Twitter::Error
      MESSAGE = "Server Error"

      # Create a new error from an HTTP environment
      #
      # @param response [Hash]
      # @return [Twitter::Error]
      def self.from_response(response={})
        _, code = parse_error(response[:body])
        new(nil, response[:response_headers], code)
      end

      # Initializes a new ServerError object
      #
      # @param message [String]
      # @param response_headers [Hash]
      # @return [Twitter::Error::ServerError]
      def initialize(message=nil, response_headers={}, code = nil)
        super((message || self.class.const_get(:MESSAGE)), response_headers, code)
      end

    end
  end
end
