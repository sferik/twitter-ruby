require 'http/request'

module Twitter
  module Streaming
    class Stream
      attr_writer :connection

      def initialize(client)
        @client = client
        @request_options = {
          :port           => 443,
          :content_type   => 'application/x-www-form-urlencoded',
          :user_agent     => @client.user_agent,
          :proxy          => nil,
          :ssl            => {},
          :timeout        => 0,
          :oauth          => @client.credentials,
          :encoding       => nil,
          :auto_reconnect => true,
        }
      end

      def user(&block)
        user!(&block).value
      end

      def user!(&block)
        request(:get, 'http://userstream.twitter.com:443/1.1/user.json') do |data|
          begin
            block.call(Twitter::Tweet.new(data))
          rescue
            p(:unknown => data)
          end
        end
      end

      def track(*keywords, &block)
        track!(keywords, &block).value
      end

      def track!(*keywords, &block)
        request(:post, 'http://stream.twitter.com:443/1.1/statuses/filter.json', {}, {}, "track=#{keywords.join(',')}") do |data|
          begin
            block.call(Twitter::Tweet.new(data))
          rescue Exception => e
            p(:unknown => data)
          end
        end
      end

      def request(method, uri, headers={}, proxy={}, body=nil, &block)
        request    = HTTP::Request.new(method, uri, headers, proxy, body)
        response   = Twitter::Streaming::Response.new(block)
        connection = @connection || Twitter::Streaming::Connection.new
        connection.future.stream(request, response)
      end

    end
  end
end
