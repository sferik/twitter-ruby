require 'twitter/stream/core/io'
require 'twitter/stream/core/common'

module Twitter
  module Stream
    class Client
      include Celluloid
      include Common

      DEFAULT_OPTIONS = {
        :host         => 'stream.twitter.com',
        :port         => 443,
        :method       => 'POST',
        :content_type => 'application/x-www-form-urlencoded',
        :headers      => {},
        :user_agent   => "Twitter Celluloid",
        :proxy        => nil,
        :ssl          => {},
        :timeout      => 0,
        :path         => '',
        :params       => {},
        :oauth        => {},
        :encoding     => nil,
      }

      def filter(params={})
        @options[:path] ='/1.1/statuses/filter.json'
        super
      end

      def sample
        @options[:path] ='/1.1/statuses/sample.json'
        super
      end

      def firehose
        @options[:path] ='/1.1/statuses/firehose.json'
        super
      end

    end
  end
end
