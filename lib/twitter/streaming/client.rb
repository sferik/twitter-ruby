require 'http/request'
require 'twitter/arguments'
require 'twitter/client'
require 'twitter/streaming/connection'
require 'twitter/streaming/response'

module Twitter
  module Streaming
    class Client < Twitter::Client
      attr_writer :connection

      def initialize(options={}, &block)
        super
        @connection = Twitter::Streaming::Connection.new
      end

      def filter(options={}, &block)
        request(:get, 'https://stream.twitter.com:443/1.1/statuses/filter.json', options, &block)
      end

      def firehose(options={}, &block)
        request(:get, 'https://stream.twitter.com:443/1.1/statuses/firehose.json', options, &block)
      end

      def sample(options={}, &block)
        request(:get, 'https://stream.twitter.com:443/1.1/statuses/sample.json', options, &block)
      end

      def site(*args, &block)
        arguments = Twitter::Arguments.new(args)
        request(:get, 'https://sitestream.twitter.com:443/1.1/site.json', arguments.options.merge(:follow => arguments.join(',')), &block)
      end

      def user(options={}, &block)
        request(:get, 'https://userstream.twitter.com:443/1.1/user.json', options, &block)
      end

      # Set a Proc to be run when connection established.
      def on_request(&block)
        if block_given?
          @on_request = block
          self
        elsif instance_variable_defined?(:@on_request)
          @on_request
        else
          Proc.new {}
        end
      end

    private

      def request(method, uri, params, &block)
        on_request.call
        headers  = default_headers.merge(:authorization => oauth_auth_header(method, uri, params).to_s)
        request  = HTTP::Request.new(method, uri + '?' + to_url_params(params), headers)
        response = Twitter::Streaming::Response.new do |data|
          yield(Tweet.new(data)) if data[:id]
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
