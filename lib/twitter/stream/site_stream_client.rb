require 'twitter/stream/core/io'
require 'twitter/stream/core/common'

module Twitter
  module Stream
    class SiteStreamClient
      include Celluloid
      include Common

      DEFAULT_OPTIONS = {
        :host => 'sitestream.twitter.com',
        :port => 443,
        :method => 'GET',
        :path => '/1.1/site.json'
      }

      def on_control(&block)
        on('control', &block)
      end

      def on_warning(&block)
        on('warning', &block)
      end

    end
  end
end
