require 'http/parser'
require 'openssl'
require 'resolv'

module Twitter
  module Streaming
    class Connection
      attr_reader :tcp_socket_class, :ssl_socket_class, :state

      def initialize(options = {})
        @tcp_socket_class = options.fetch(:tcp_socket_class) { TCPSocket }
        @ssl_socket_class = options.fetch(:ssl_socket_class) { OpenSSL::SSL::SSLSocket }
        @state = :initialized
      end

      # Initiate a socket connection and setup response handling
      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        client         = @tcp_socket_class.new(Resolv.getaddress(request.uri.host), request.uri.port)
        @ssl_client    = @ssl_socket_class.new(client, client_context)

        @state = :connecting
        @ssl_client.connect
        request.stream(@ssl_client)
        @state = :connected
        while connected? && (body = @ssl_client.readpartial(1024)) # rubocop:disable AssignmentInCondition, WhileUntilModifier
          response << body
        end
      end

      # Close the connection when it's in a closeable state
      def close
        return unless closeable?

        @state = :closing
        @ssl_client.close
        @state = :closed
      end

    private

      def connected?
        @state == :connected
      end

      def connecting?
        @state == :connecting
      end

      def closeable?
        connected? || connecting?
      end
    end
  end
end
