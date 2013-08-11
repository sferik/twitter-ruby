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
          # TODO: do not use send
          :oauth          => @client.send(:credentials),
          :encoding       => nil,
          :auto_reconnect => true,
        }
      end

      def user
        user!.value
      end

      def user!
        request({
          :method         => 'GET',
          :host           => 'userstream.twitter.com',
          :path           => '/1.1/user.json',
          :params         => {},
        }) do |data|
          begin
            yield Tweet.new(data)
          rescue
            p(:unknown => data)
          end
        end
      end

      def track(*keywords)
        track!.value
      end

      def track!(*keywords)
        options = {
          :method         => 'POST',
          :host           => 'stream.twitter.com',
          :path           => '/1.1/statuses/filter.json',
          :params         => {'track' => keywords.join(',')},
        }
        request(options) do |data|
          begin
            yield Tweet.new(data)
          rescue
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
