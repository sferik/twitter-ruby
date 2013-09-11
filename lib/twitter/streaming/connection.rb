require 'http/parser'
require 'openssl'
require 'resolv'

module Twitter
  module Streaming
    class Connection

      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        client         = TCPSocket.new(Resolv.getaddress(request.uri.host), request.uri.port)
        ssl_client     = OpenSSL::SSL::SSLSocket.new(client, client_context)
        ssl_client.connect
        request.stream(ssl_client)
        while body = ssl_client.readpartial(1024)
          response << body
        end
      end

    end
  end
end
