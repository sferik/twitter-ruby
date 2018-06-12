require 'helper'

describe Twitter::Streaming::Connection do
  describe 'initialize' do
    context 'no options provided' do
      subject(:connection) { Twitter::Streaming::Connection.new }

      it 'sets the default socket classes' do
        expect(connection.tcp_socket_class).to eq TCPSocket
        expect(connection.ssl_socket_class).to eq OpenSSL::SSL::SSLSocket
      end
    end

    context 'custom socket classes provided in opts' do
      class DummyTCPSocket; end
      class DummySSLSocket; end

      subject(:connection) do
        Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
      end

      it 'sets the default socket classes' do
        expect(connection.tcp_socket_class).to eq DummyTCPSocket
        expect(connection.ssl_socket_class).to eq DummySSLSocket
      end
    end
  end

  describe 'connection' do
    class DummyResponse
      def initiailze
        yield
      end

      def <<(data); end
    end

    subject(:connection) do
      Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    let(:method) { :get }
    let(:uri)    { 'https://stream.twitter.com:443/1.1/statuses/sample.json' }
    let(:ssl_socket) { double('ssl_socket') }

    let(:request) { HTTP::Request.new(verb: method, uri: uri) }

    it 'requests via the proxy' do
      expect(connection.ssl_socket_class).to receive(:new).and_return(ssl_socket)
      allow(ssl_socket).to receive(:connect)

      expect(connection).to receive(:new_tcp_socket).with('stream.twitter.com', 443)
      connection.connect(request)
    end

    context 'when using a proxy' do
      let(:proxy) { {proxy_address: '127.0.0.1', proxy_port: 3328} }
      let(:request) { HTTP::Request.new(verb: method, uri: uri, proxy: proxy) }

      it 'requests via the proxy' do
        expect(connection).to receive(:new_tcp_socket).with('127.0.0.1', 3328)
        connection.connect(request)
      end

      context 'if using ssl' do
        subject(:connection) do
          Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket, using_ssl: true)
        end

        it 'connect with ssl' do
          expect(connection.ssl_socket_class).to receive(:new).and_return(ssl_socket)
          allow(ssl_socket).to receive(:connect)

          expect(connection).to receive(:new_tcp_socket).with('127.0.0.1', 3328)
          connection.connect(request)
        end
      end
    end
  end

  describe 'stream' do
    subject(:connection) do
      Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    let(:method) { :get }
    let(:uri)    { 'https://stream.twitter.com:443/1.1/statuses/sample.json' }
    let(:client) {  TCPSocket.new('127.0.0.1', 8443) }

    let(:request) { HTTP::Request.new(verb: method, uri: uri) }
    let(:response) { DummyResponse.new {} }

    before do
      @server = TCPServer.new('127.0.0.1', 8443)
    end

    after do
      @server.close
    end

    it 'close stream' do
      expect(connection).to receive(:connect).with(request).and_return(client)
      expect(request).to receive(:stream).with(client)

      stream_closed = false
      t = Thread.start do
        connection.stream(request, response)
        stream_closed = true
      end
      expect(stream_closed).to be false
      sleep 1
      connection.close
      t.join
      expect(stream_closed).to be true
    end
  end
end
