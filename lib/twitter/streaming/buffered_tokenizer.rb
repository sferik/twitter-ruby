module Twitter
  module Streaming
    class BufferedTokenizer
      def initialize(delimiter)
        @delimiter = delimiter
        @buffer = ""
      end

      def extract(data)
        @buffer << data
        items = @buffer.split(@delimiter)
        if @buffer.end_with?(@delimiter)
          @buffer.clear
          items
        else
          @buffer = items.pop
          items
        end
      end
    end
  end
end
