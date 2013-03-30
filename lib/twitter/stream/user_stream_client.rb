require 'twitter/stream/core/io'
require 'twitter/stream/core/common'

module Twitter
  module Stream
    class UserStreamClient
      include Celluloid
      include Common

      DEFAULT_OPTIONS = {
        :host => 'userstream.twitter.com',
        :port => 443,
        :path => '/1.1/user.json'
      }

      def on_friends(&block)
        on('friends', &block)
      end

      def on_event(event, &block)
        on(event, &block)
      end

      def on_warning(&block)
        on('warning', &block)
      end

      def on_direct_message(&block)
        on('direct_message', &block)
      end

    end
  end
end
