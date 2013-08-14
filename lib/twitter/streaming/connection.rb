module Twitter
  module Streaming
    class Connection
      include Celluloid::IO

      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        parser         = Http::Parser.new(response)
        uri            = request.uri
        client         = Celluloid::IO::TCPSocket.new(Resolv.getaddress(uri.host), uri.port)
        ssl_socket     = Celluloid::IO::SSLSocket.new(client, client_context)
        request.stream(ssl_socket)
      rescue EOFError
        puts "Stream ended"
      end

    end
  end
end
