require 'http/parser'
require 'openssl'
require 'resolv'

module Twitter
  module Streaming
    class Connection
      attr_reader :tcp_socket_class, :ssl_socket_class, :keepalive

      DEFAULT_KEEPALIVE_SETTINGS = {
        idle_timeout: 60,
        interval: 10,
        count: 6,
      }.freeze

      def initialize(opts = {})
        @tcp_socket_class = opts.fetch(:tcp_socket_class) { TCPSocket }
        @ssl_socket_class = opts.fetch(:ssl_socket_class) { OpenSSL::SSL::SSLSocket }
        @keepalive = DEFAULT_KEEPALIVE_SETTINGS.merge(opts.fetch(:keepalive) { {enabled: false} })
        @write_pipe = nil
      end

      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        client         = new_tcp_socket(request.socket_host, request.socket_port)
        ssl_client     = @ssl_socket_class.new(client, client_context)

        ssl_client.connect
        request.stream(ssl_client)
        read_pipe, @write_pipe = IO.pipe
        loop do
          read_ios, _write_ios, _exception_ios = IO.select([read_pipe, ssl_client])
          case read_ios.first
          when ssl_client
            response << ssl_client.readpartial(1024)
          when read_pipe
            break
          end
        end
        ssl_client.close
        client.close
      end

      def close
        @write_pipe.write('q') if @write_pipe
      end

    private

      def new_tcp_socket(host, port)
        @tcp_socket_class.new(Resolv.getaddress(host), port).tap do |socket|
          # Check that Socket::TCP_KEEPIDLE is present, so we know we can access these socket options
          if @keepalive[:enabled] && defined?(Socket::TCP_KEEPIDLE)
            socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)
            socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_KEEPIDLE, @keepalive[:idle_timeout])
            socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_KEEPINTVL, @keepalive[:interval])
            socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_KEEPCNT, @keepalive[:count])
          end
        end
      end
    end
  end
end
