require 'http/parser'
require 'openssl'
require 'resolv'

module Twitter
  module Streaming
    class Connection
      def initialize(opts = {})
        @tcp_socket_class = opts.fetch(:tcp_socket_class) { TCPSocket }
        @ssl_socket_class = opts.fetch(:ssl_socket_class) { OpenSSL::SSL::SSLSocket }
      end
      attr_reader :tcp_socket_class, :ssl_socket_class

      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        client         = @tcp_socket_class.new(Resolv.getaddress(request.uri.host), request.uri.port)
        ssl_client     = @ssl_socket_class.new(client, client_context)

        ssl_client.connect
        request.stream(ssl_client)
        loop {
          begin
            body = ssl_client.read_nonblock(1024) # rubocop:disable AssignmentInCondition, WhileUntilModifier
            response << body
          rescue IO::WaitReadable
            # The reason for setting 90 seconds as a timeout is documented on:
            # https://dev.twitter.com/streaming/overview/connecting
            r, w, e = IO.select([ssl_client], [], [], 90)
            if r.nil?
              # If timeout occurs
              ssl_client.close
              raise Twitter::Error::ServerError.new("Connection stalled")
            else
              # If socket is readable
              retry
            end
          end
        }
      end
    end
  end
end
