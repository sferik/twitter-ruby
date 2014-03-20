require 'http/parser'
require 'openssl'
require 'resolv'

module Twitter
  module Streaming
    class Connection

      def initialize(opts = {})
        @tcp_socket_klass = opts.fetch(:tcp_socket_klass) { TCPSocket }
        @ssl_socket_klass = opts.fetch(:ssl_socket_klass) { OpenSSL::SSL::SSLSocket }
      end
      attr_reader :tcp_socket_klass, :ssl_socket_klass

      def stream(request, response, opts = {})
        client_context = OpenSSL::SSL::SSLContext.new
        client         = @tcp_socket_klass.new(Resolv.getaddress(request.uri.host), request.uri.port)
        ssl_client     = @ssl_socket_klass.new(client, client_context)

        ssl_client.connect
        request.stream(ssl_client)
        while body = ssl_client.readpartial(1024) # rubocop:disable AssignmentInCondition, WhileUntilModifier
          response << body
        end
      end
    end
  end
end
