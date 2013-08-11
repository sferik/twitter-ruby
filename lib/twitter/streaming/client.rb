require 'twitter/client'
require 'twitter/streaming/connection'
require 'twitter/streaming/proxy'
require 'twitter/streaming/request'
require 'twitter/streaming/response'

module Twitter
  module Streaming
    class Client < Twitter::Client
      attr_writer :connection

      def initialize
        super
        @connection = Twitter::Streaming::Connection.new
        @request_options = {
          :auto_reconnect => true,
          :content_type   => 'application/x-www-form-urlencoded',
          :headers        => {},
          :oauth          => credentials,
          :port           => 443,
          :ssl            => true,
          :timeout        => 0,
          :user_agent     => user_agent,
        }
      end

      def user(&block)
        user!(&block).value
      end

      def user!(&block)
        request({
          :method         => 'GET',
          :host           => 'userstream.twitter.com',
          :path           => '/1.1/user.json',
          :params         => {},
        }) do |data|
          begin
            block.call(Tweet.new(data))
          rescue StandardError => error
            p(error)
          end
        end
      end

      def track(*keywords, &block)
        track!(*keywords, &block).value
      end

      def track!(*keywords, &block)
        options = {
          :method         => 'POST',
          :host           => 'stream.twitter.com',
          :path           => '/1.1/statuses/filter.json',
          :params         => {'track' => keywords.join(',')},
        }
        request(options) do |data|
          begin
            block.call(Tweet.new(data))
          rescue StandardError => error
            p(error)
          end
        end
      end

      def request(options, &block)
        # TODO: consider HTTP::Request
        request    = Twitter::Streaming::Request.new(@request_options.merge(options))
        response   = Twitter::Streaming::Response.new(block)
        @connection.future.stream(request, response)
      end

    end
  end
end
