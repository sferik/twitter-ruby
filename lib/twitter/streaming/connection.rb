require 'celluloid/io'
require 'http/parser'
require 'openssl'
require 'resolv'

module Twitter
  module Streaming
    class Connection
      include Celluloid::IO

      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        parser         = Http::Parser.new(response)
        client         = Celluloid::IO::TCPSocket.new(Resolv.getaddress(request.host), request.port)
        ssl_client     = Celluloid::IO::SSLSocket.new(client, client_context)
        ssl_client.connect
        # TODO: HTTP::Request#stream
        ssl_client.write(request.to_s)

        while body = ssl_client.readpartial(1024)
          parser << body
        end
      rescue EOFError
        puts "Stream ended"
      end

    end
  end
end
