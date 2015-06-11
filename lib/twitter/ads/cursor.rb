require 'twitter/cursor'

module Twitter
  module Ads
    class Cursor < Twitter::Cursor
      def initialize(key, klass, request)
        super
        @path = request.uri.to_s
      end

      def next_cursor
        @attrs[:next_cursor]
      end

      def last?
        next_cursor.nil?
      end
    end
  end
end
