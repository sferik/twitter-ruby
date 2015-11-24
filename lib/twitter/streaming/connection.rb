require 'http/parser'
require 'openssl'
require 'resolv'

module Twitter
  module Streaming
    class Connection
      attr_reader :tcp_socket_class, :ssl_socket_class

      def initialize(options = {})
        @tcp_socket_class = options.fetch(:tcp_socket_class) { TCPSocket }
        @ssl_socket_class = options.fetch(:ssl_socket_class) { OpenSSL::SSL::SSLSocket }
      end

      def stream(request, response)
        ssl_client = connect(request)
        request.stream(ssl_client)
        while body = ssl_client.readpartial(1024) # rubocop:disable AssignmentInCondition
          response << body
        end
      end

      def connect(request)
        client_context = OpenSSL::SSL::SSLContext.new
        client         = new_tcp_socket(request.socket_host, request.socket_port)
        ssl_client     = @ssl_socket_class.new(client, client_context)

        ssl_client.connect
      end

      private

      def new_tcp_socket(host, port)
        @tcp_socket_class.new(Resolv.getaddress(host), port)
      end
    end
  end
end
