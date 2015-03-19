require 'helper'

class DummyUri
  def initialize; end

  def host
    '127.0.0.1'
  end

  def port
    22
  end
end

class DummyRequest
  def initialize; end

  def uri
    DummyUri.new
  end

  def stream(_); end
end

class DummyTCPSocket
  def initialize(_a, _b); end
end

class DummyResponse
  def initialize; end

  def <<(_); end
end

class FakeStalledSSLSocket < IO
  def initialize(_a, _b)
    @rpipe, @wpipe = IO.pipe
    super(@rpipe.fileno)
  end

  def connect; end

  def <<(_); end

  def readpartial(_); end

  def close; end
end

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
        Twitter::Streaming::Connection.new(:tcp_socket_class => DummyTCPSocket, :ssl_socket_class => DummySSLSocket)
      end

      it 'sets the default socket classes' do
        expect(connection.tcp_socket_class).to eq DummyTCPSocket
        expect(connection.ssl_socket_class).to eq DummySSLSocket
      end
    end
  end

  describe 'Socket I/O timeout' do
    context 'setting read timeout to 3 seconds' do
      subject(:connection) do
        Twitter::Streaming::Connection.new(:tcp_socket_class => DummyTCPSocket, :ssl_socket_class => FakeStalledSSLSocket, :select_timeout => 3)
      end

      context 'stalled socket is given' do
        it 'causes Twitter::Error::ServerError after 3 seconds passes' do
          expect { connection.stream(DummyRequest.new, DummyResponse.new) }.to raise_error(Twitter::Error::ServerError)
        end
      end
    end
  end
end
