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
        client_context = OpenSSL::SSL::SSLContext.new
        client         = @tcp_socket_class.new(Resolv.getaddress(request.uri.host), request.uri.port)
        ssl_client     = @ssl_socket_class.new(client, client_context)

        ssl_client.connect
        request.stream(ssl_client)
        while body = ssl_client.readpartial(1024) # rubocop:disable AssignmentInCondition, WhileUntilModifier
          response << body
        end
      end
    end
  end
end
