require 'celluloid/io'
require 'http/parser'
require 'resolv'
require 'openssl'

require 'twitter/stream/core/proxy'
require 'twitter/stream/core/request'
require 'twitter/stream/core/response'

module Twitter
  module Stream
    class IO
      include Celluloid::IO

      def initialize(host, port)
        @reconnect_manager = Twitter::Stream::ReconnectManager.new
        client_context     = OpenSSL::SSL::SSLContext.new
        @parser            = Http::Parser.new(self)
        client             = Celluloid::IO::TCPSocket.new(host, port)
        @ssl_client        = Celluloid::IO::SSLSocket.new(client, client_context)
        @response          = Response.new
      end

      def on_headers_complete(headers)
        @response_code  = @parser.status_code.to_i

        case @response_code
        when 200 then @reconnect_manager.reset
        when 401 then @stream_client.invoke_callback(:unauthorized)
        when 403 then @stream_client.invoke_callback(:forbidden)
        when 404 then @stream_client.invoke_callback(:not_found)
        when 406 then @stream_client.invoke_callback(:not_acceptable)
        when 413 then @stream_client.invoke_callback(:too_long)
        when 416 then @stream_client.invoke_callback(:range_unacceptable)
        when 420 then @stream_client.invoke_callback(:enhance_your_calm)
        when 503 then @stream_client.invoke_callback(:service_unavailable)
        else
          msg = "Unhandled status code: #{@response_code}."
          @stream_client.invoke_callback(:error, msg)
        end
      end

      def on_body(data)
        return unless @stream_client

        @response << data
        if @response.complete?
          body = @response.body and @response.reset
          @stream_client.handle_response(body)
        end
      end

      def stream(stream_client)
        @stream_client = stream_client
        @ssl_client.connect
        @ssl_client.write(stream_client.request.to_s)
        handle_connection
      end

      private

      def handle_connection
        while body = @ssl_client.read(1024)
          @parser << body
        end
      end
    end
  end
end
