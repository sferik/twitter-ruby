require 'helper'

describe Twitter::Streaming::Connection do
  describe 'initialize' do
    context 'no options provided' do
      subject(:connection) { Twitter::Streaming::Connection.new }

      it 'sets the default socket classes' do
        expect(connection.tcp_socket_class).to eq TCPSocket
        expect(connection.ssl_socket_class).to eq OpenSSL::SSL::SSLSocket
      end

      it 'sets keepalive as disabled' do
        expect(connection.keepalive).to include(enabled: false)
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

    context 'custom keepalive settings' do
      let(:keepalive_settings) do
        {
          enabled: true,
          idle_timeout: 30,
          interval: 15,
          count: 10
        }
      end

      subject(:connection) { Twitter::Streaming::Connection.new(keepalive: keepalive_settings) }

      it "uses the custom keepalive settings" do
        expect(connection.keepalive).to eq keepalive_settings
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

    it 'requests directly' do
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

    context 'with keepalive settings' do
      subject(:connection) { Twitter::Streaming::Connection.new(keepalive: keepalive_settings, ssl_socket_class: DummySSLSocket) }

      let(:keepalive_settings) do
        {
          enabled: true,
          idle_timeout: 30,
          interval: 15,
          count: 10,
        }
      end

      let(:socket) { instance_double(TCPSocket) }

      before do
        allow(Resolv).to receive(:getaddress).and_return('104.244.42.1')
        allow(TCPSocket).to receive(:new).and_return(socket)
        allow(socket).to receive(:setsockopt)
        allow(DummySSLSocket).to receive(:new).and_return(ssl_socket)
        allow(ssl_socket).to receive(:connect)
      end

      it 'sets the keepalive settings if able' do
        stub_const('Socket::SO_KEEPALIVE', :SO_KEEPALIVE)
        stub_const('Socket::TCP_KEEPIDLE', :TCP_KEEPIDLE)
        stub_const('Socket::TCP_KEEPINTVL', :TCP_KEEPINTVL)
        stub_const('Socket::TCP_KEEPCNT', :TCP_KEEPCNT)
        stub_const('Socket::SOL_SOCKET', :SOL_SOCKET)
        stub_const('Socket::IPPROTO_TCP', :IPPROTO_TCP)

        connection.connect(request)

        expect(socket).to have_received(:setsockopt).with(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)
        expect(socket).to have_received(:setsockopt).with(Socket::IPPROTO_TCP, Socket::TCP_KEEPIDLE, 30)
        expect(socket).to have_received(:setsockopt).with(Socket::IPPROTO_TCP, Socket::TCP_KEEPINTVL, 15)
        expect(socket).to have_received(:setsockopt).with(Socket::IPPROTO_TCP, Socket::TCP_KEEPCNT, 10)
      end

      context 'with keepalive disabled' do
        let(:keepalive_settings) { {enabled: false} }

        it 'does not attempt to set keepalive settings' do
          connection.connect(request)

          expect(socket).not_to have_received(:setsockopt)
        end
      end
    end
  end
end
