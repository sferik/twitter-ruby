require 'buftok'

module Twitter
  module Streaming
    class Response
      def initialize(block)
        @block     = block
        @tokenizer = BufferedTokenizer.new("\r\n")
      end

      def on_headers_complete(headers)
        puts headers
        # handle response codes
      end

      def on_body(data)
        @tokenizer.extract(data).each do |line|
          next if line.empty?
          @block.call(JSON.parse(line, :symbolize_names => true))
        end
      end

    end
  end
end
