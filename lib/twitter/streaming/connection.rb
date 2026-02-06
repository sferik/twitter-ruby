require "openssl"
require "resolv"

module Twitter
  module Streaming
    # Manages TCP/SSL connections for streaming
    #
    # @api public
    class Connection
      # Returns the TCP socket class
      #
      # @api public
      # @example
      #   connection.tcp_socket_class
      # @return [Class]

      # Returns the SSL socket class
      #
      # @api public
      # @example
      #   connection.ssl_socket_class
      # @return [Class]
      attr_reader :tcp_socket_class, :ssl_socket_class

      # Initializes a new Connection object
      #
      # @api public
      # @example
      #   connection = Twitter::Streaming::Connection.new
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::Streaming::Connection]
      def initialize(options = {})
        @tcp_socket_class = options.fetch(:tcp_socket_class) { TCPSocket } # steep:ignore UnknownConstant
        @ssl_socket_class = options.fetch(:ssl_socket_class) { OpenSSL::SSL::SSLSocket } # steep:ignore UnknownConstant
        @using_ssl        = options.fetch(:using_ssl, false)
      end

      # Streams data from the connection
      #
      # @api public
      # @example
      #   connection.stream(request, response)
      # @param request [HTTP::Request] The HTTP request.
      # @param response [Twitter::Streaming::Response] The response handler.
      # @return [void]
      def stream(request, response) # rubocop:disable Metrics/MethodLength
        client = connect(request)
        request.stream(client)
        read_pipe, @write_pipe = IO.pipe
        loop do
          read_ios, _write_ios, _exception_ios = IO.select([read_pipe, client])
          case read_ios.first
          when client
            response << client.readpartial(1024)
          when read_pipe
            break
          end
        end
        client.close
      end

      # Connects to the specified host and port
      #
      # @api public
      # @example
      #   connection.connect(request)
      # @param request [HTTP::Request] The HTTP request.
      # @return [TCPSocket, OpenSSL::SSL::SSLSocket]
      def connect(request)
        client = new_tcp_socket(request.socket_host, request.socket_port)
        return client if !@using_ssl && request.using_proxy?

        client_context = OpenSSL::SSL::SSLContext.new # steep:ignore UnknownConstant
        ssl_client     = @ssl_socket_class.new(client, client_context)
        ssl_client.connect
      end

      # Closes the connection
      #
      # @api public
      # @example
      #   connection.close
      # @return [Integer, nil]
      def close
        @write_pipe&.write("q")
      end

    private

      # Creates a new TCP socket
      #
      # @api private
      # @return [TCPSocket]
      def new_tcp_socket(host, port)
        @tcp_socket_class.new(Resolv.getaddress(host), port) # steep:ignore UnknownConstant
      end
    end
  end
end
