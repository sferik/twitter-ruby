module Twitter
  module Streaming
    class Stream
      attr_writer :connection

      def initialize(client)
        @client = client
        @request_options = {
          :port           => 443,
          :content_type   => 'application/x-www-form-urlencoded',
          :headers        => {},
          :user_agent     => 'Twitter Celluloid',
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
        options = {
          :method         => 'GET',
          :host           => 'userstream.twitter.com',
          :path           => '/1.1/user.json',
          :params         => {},
        }
        request(options) do |data|
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
        options = {
          :method         => 'POST',
          :host           => 'stream.twitter.com',
          :path           => '/1.1/statuses/filter.json',
          :params         => {'track' => keywords.join(',')},
        }
        request(options) do |data|
          begin
            block.call(Twitter::Tweet.new(data))
          rescue Exception => e
            p(:unknown => data)
          end
        end
      end

      def request(options, &block)
        # TODO: consider HTTP::Request
        request    = Twitter::Streaming::Request.new(@request_options.merge(options))
        response   = Twitter::Streaming::Response.new(block)
        connection = @connection || Twitter::Streaming::Connection.new
        connection.future.stream(request, response)
      end

    end
  end
end
