require "buftok"
require "http"
require "json"
require "twitter/error"
require "llhttp"

module Twitter
  module Streaming
    # Handles streaming response parsing
    #
    # @api public
    class Response
      # Initializes a new Response object
      #
      # @api public
      # @example
      #   response = Twitter::Streaming::Response.new { |data| puts data }
      # @return [Twitter::Streaming::Response]
      def initialize(&block)
        @block     = block
        @parser    = LLHttp::Parser.new(self, type: :response)
        @tokenizer = BufferedTokenizer.new("\r\n")
      end

      # Appends data to the parser
      #
      # @api public
      # @example
      #   response << data
      # @param data [String] The data to append.
      # @return [void]
      def <<(data)
        @parser << data
      end

      # Handles body data from the response
      #
      # @api public
      # @example
      #   response.on_body(data)
      # @param data [String] The body data.
      # @return [void]
      def on_body(data)
        @tokenizer.extract(data).each do |line|
          next if line.empty?

          @block.call(JSON.parse(line, symbolize_names: true))
        end
      end

      # Handles status code from the response
      #
      # @api public
      # @example
      #   response.on_status(200)
      # @param _status [Integer] The status code.
      # @return [void]
      def on_status(_status)
        error = Twitter::Error::ERRORS[@parser.status_code]
        raise error if error
      end
    end
  end
end
