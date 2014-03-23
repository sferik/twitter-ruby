require 'helper'

describe Twitter::Streaming::Connection do

  describe 'initialize' do

    context "no options provided" do
      subject(:connection) { Twitter::Streaming::Connection.new }

      it "sets the default socket classes" do
        expect(connection.tcp_socket_klass).to eq TCPSocket
        expect(connection.ssl_socket_klass).to eq OpenSSL::SSL::SSLSocket
      end
    end

    context "custom socket classes provided in opts" do
      class DummyTCPSocket; end
      class DummySSLSocket; end

      subject(:connection) { Twitter::Streaming::Connection.new(
        tcp_socket_klass: DummyTCPSocket,
        ssl_socket_klass: DummySSLSocket
      )}

      it "sets the default socket classes" do
        expect(connection.tcp_socket_klass).to eq DummyTCPSocket
        expect(connection.ssl_socket_klass).to eq DummySSLSocket
      end
    end

  end

end

