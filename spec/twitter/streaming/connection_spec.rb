require "helper"

DummyTCPSocket = Class.new

class DummySSLSocket
  def connect; end
end

class DummyResponse
  def initiailze
    yield
  end

  def <<(data); end
end

describe Twitter::Streaming::Connection do
  describe "initialize" do
    context "no options provided" do
      subject(:connection) { described_class.new }

      it "sets the default socket classes" do
        expect(connection.tcp_socket_class).to eq TCPSocket
        expect(connection.ssl_socket_class).to eq OpenSSL::SSL::SSLSocket
      end
    end

    context "custom socket classes provided in opts" do
      subject(:connection) do
        described_class.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
      end

      it "sets the default socket classes" do
        expect(connection.tcp_socket_class).to eq DummyTCPSocket
        expect(connection.ssl_socket_class).to eq DummySSLSocket
      end
    end
  end

  describe "connection" do
    subject(:connection) do
      described_class.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    let(:method) { :get }
    let(:uri)    { "https://stream.twitter.com:443/1.1/statuses/sample.json" }
    let(:ssl_socket) { instance_double(connection.ssl_socket_class) }

    let(:request) { HTTP::Request.new(verb: method, uri:) }

    it "requests via the proxy" do
      expect(connection.ssl_socket_class).to receive(:new).and_return(ssl_socket)
      allow(ssl_socket).to receive(:connect)

      expect(connection).to receive(:new_tcp_socket).with("stream.twitter.com", 443)
      connection.connect(request)
    end

    context "when using a proxy" do
      let(:proxy) { {proxy_address: "127.0.0.1", proxy_port: 3328} }
      let(:request) { HTTP::Request.new(verb: method, uri:, proxy:) }

      it "requests via the proxy" do
        expect(connection).to receive(:new_tcp_socket).with("127.0.0.1", 3328)
        connection.connect(request)
      end

      it "creates a real TCP socket when connecting via proxy without SSL" do
        server = TCPServer.new("::", 0)
        port = server.addr[1]
        proxy_opts = {proxy_address: "localhost", proxy_port: port}
        proxy_request = HTTP::Request.new(verb: method, uri:, proxy: proxy_opts)

        connection_instance = described_class.new(tcp_socket_class: TCPSocket, ssl_socket_class: DummySSLSocket, using_ssl: false)

        accepted_socket = nil
        t = Thread.start { accepted_socket = server.accept }

        client = connection_instance.connect(proxy_request)
        t.join

        expect(client).to be_a(TCPSocket)
        expect(accepted_socket).not_to be_nil

        client.close
        accepted_socket&.close
        server.close
      end

      context "if using ssl" do
        subject(:connection) do
          described_class.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket, using_ssl: true)
        end

        it "connect with ssl" do
          expect(connection.ssl_socket_class).to receive(:new).and_return(ssl_socket)
          allow(ssl_socket).to receive(:connect)

          expect(connection).to receive(:new_tcp_socket).with("127.0.0.1", 3328)
          connection.connect(request)
        end
      end
    end
  end

  describe "#close" do
    subject(:connection) do
      described_class.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    it "does nothing when write_pipe is nil" do
      # write_pipe is nil before stream is called
      expect { connection.close }.not_to raise_error
    end
  end

  describe "stream" do
    subject(:connection) do
      described_class.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    let(:method) { :get }
    let(:uri)    { "https://stream.twitter.com:443/1.1/statuses/sample.json" }
    let(:client) {  TCPSocket.new("127.0.0.1", @server.addr[1]) }

    let(:request) { HTTP::Request.new(verb: method, uri:) }
    let(:response) { DummyResponse.new {} }

    before do
      @server = TCPServer.new("127.0.0.1", 0)
    end

    after do
      @server.close
    end

    it "close stream" do
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

    it "reads data from the client and passes it to the response" do
      received_data = []
      response_with_capture = Class.new do
        define_method(:initialize) { |&block| @received = received_data }
        define_method(:<<) { |data| @received << data }
      end.new {}

      expect(connection).to receive(:connect).with(request).and_return(client)
      expect(request).to receive(:stream).with(client)

      t = Thread.start do
        connection.stream(request, response_with_capture)
      end

      # Send data from server to client
      server_client = @server.accept
      server_client.write("test data")
      server_client.flush

      # Give time for data to be read
      sleep 0.1

      # Close the stream
      connection.close
      t.join
      server_client.close

      expect(received_data).to include("test data")
    end
  end

end
