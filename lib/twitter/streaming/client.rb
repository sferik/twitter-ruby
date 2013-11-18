require 'http/request'
require 'twitter/arguments'
require 'twitter/client'
require 'twitter/streaming/connection'
require 'twitter/streaming/response'
require 'twitter/streaming/message_parser'
require 'twitter/streaming/event'
require 'twitter/streaming/friend_list'

module Twitter
  module Streaming
    class Client < Twitter::Client
      attr_writer :connection

      # Initializes a new Client object
      #
      # @return [Twitter::Streaming::Client]
      def initialize(options={}, &block)
        super
        @connection = Streaming::Connection.new
      end

      # @yield [Twitter::Tweet] A stream of tweets.
      def filter(options={}, &block)
        request(:post, 'https://stream.twitter.com:443/1.1/statuses/filter.json', options, &block)
      end

      # @yield [Twitter::Tweet] A stream of tweets.
      def firehose(options={}, &block)
        request(:get, 'https://stream.twitter.com:443/1.1/statuses/firehose.json', options, &block)
      end

      # @yield [Twitter::Tweet] A stream of tweets.
      def sample(options={}, &block)
        request(:get, 'https://stream.twitter.com:443/1.1/statuses/sample.json', options, &block)
      end

      # @yield [Twitter::Tweet] A stream of tweets.
      def site(*args, &block)
        arguments = Arguments.new(args)
        request(:get, 'https://sitestream.twitter.com:443/1.1/site.json', arguments.options.merge(:follow => arguments.join(',')), &block)
      end

      # @yield [Twitter::Tweet] A stream of tweets.
      def user(options={}, &block)
        request(:get, 'https://userstream.twitter.com:443/1.1/user.json', options, &block)
      end

      # Set a Proc to be run when connection established.
      def before_request(&block)
        if block_given?
          @before_request = block
          self
        elsif instance_variable_defined?(:@before_request)
          @before_request
        else
          Proc.new {}
        end
      end

    private

      def request(method, uri, params, &block)
        before_request.call
        headers  = default_headers.merge(:authorization => oauth_auth_header(method, uri, params).to_s)
        request  = HTTP::Request.new(method, uri + '?' + to_url_params(params), headers)
        response = Streaming::Response.new do |data|
          if item = Streaming::MessageParser.parse(data)
            yield item
          end
        end
        @connection.stream(request, response)
      end

      def to_url_params(params)
        params.map do |param, value|
          [param, URI.encode(value)].join("=")
        end.sort.join('&')
      end

      def default_headers
        @default_headers ||= {
          :accept     => '*/*',
          :user_agent => user_agent,
        }
      end
    end
  end
end
