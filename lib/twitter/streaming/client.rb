require 'twitter/arguments'
require 'twitter/client'
require 'twitter/streaming/connection'
require 'twitter/streaming/proxy'
require 'twitter/streaming/request'
require 'twitter/streaming/response'

module Twitter
  module Streaming
    class Client < Twitter::Client
      attr_writer :connection

      def initialize(options={}, &block)
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

      def firehose(options={}, &block)
        firehose!(options, &block).value
      end

      def firehose!(options={}, &block)
        request({
          :method => 'GET',
          :host   => 'stream.twitter.com',
          :path   => '/1.1/statuses/firehose.json',
          :params => options,
        }) do |data|
          begin
            block.call(Tweet.new(data)) if data[:id]
          rescue StandardError => error
            p(data)
            p(error)
          end
        end
      end

      def follow(*args, &block)
        follow!(*args, &block).value
      end

      def follow!(*args, &block)
        arguments = Twitter::Arguments.new(args)
        request({
          :method => 'POST',
          :host   => 'stream.twitter.com',
          :path   => '/1.1/statuses/filter.json',
          :params => arguments.options.merge(:follow => arguments.join(',')),
        }) do |data|
          begin
            block.call(Tweet.new(data)) if data[:id]
          rescue StandardError => error
            p(data)
            p(error)
          end
        end
      end

      def locations(*args, &block)
        locations!(*args, &block).value
      end

      def locations!(*args, &block)
        arguments = Twitter::Arguments.new(args)
        request({
          :method => 'POST',
          :host   => 'stream.twitter.com',
          :path   => '/1.1/statuses/filter.json',
          :params => arguments.options.merge(:locations => arguments.join(',')),
        }) do |data|
          begin
            block.call(Tweet.new(data)) if data[:id]
          rescue StandardError => error
            p(data)
            p(error)
          end
        end
      end

      def sample(options={}, &block)
        sample!(options, &block).value
      end

      def sample!(options={}, &block)
        request({
          :method => 'GET',
          :host   => 'stream.twitter.com',
          :path   => '/1.1/statuses/sample.json',
          :params => options,
        }) do |data|
          begin
            block.call(Tweet.new(data)) if data[:id]
          rescue StandardError => error
            p(data)
            p(error)
          end
        end
      end

      def site(*args, &block)
        site!(*args, &block).value
      end

      def site!(*args, &block)
        arguments = Twitter::Arguments.new(args)
        request({
          :method => 'POST',
          :host   => 'sitestream.twitter.com',
          :path   => '/1.1/site.json',
          :params => arguments.options.merge(:follow => arguments.join(',')),
        }) do |data|
          begin
            block.call(Tweet.new(data)) if data[:id]
          rescue StandardError => error
            p(data)
            p(error)
          end
        end
      end

      def track(*args, &block)
        track!(*args, &block).value
      end

      def track!(*args, &block)
        arguments = Twitter::Arguments.new(args)
        request({
          :method => 'POST',
          :host   => 'stream.twitter.com',
          :path   => '/1.1/statuses/filter.json',
          :params => arguments.options.merge(:track => arguments.join(',')),
        }) do |data|
          begin
            block.call(Tweet.new(data)) if data[:id]
          rescue StandardError => error
            p(data)
            p(error)
          end
        end
      end

      def user(options={}, &block)
        user!(options, &block).value
      end

      def user!(options={}, &block)
        request({
          :method => 'GET',
          :host   => 'userstream.twitter.com',
          :path   => '/1.1/user.json',
          :params => options,
        }) do |data|
          begin
            block.call(Tweet.new(data)) if data[:id]
          rescue StandardError => error
            p(data)
            p(error)
          end
        end
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

      def request(options, &block)
        on_request.call
        # TODO: consider HTTP::Request
        request  = Twitter::Streaming::Request.new(@request_options.merge(options))
        response = Twitter::Streaming::Response.new(block)
        @connection.future.stream(request, response)
      end

    end
  end
end
