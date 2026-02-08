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

    it "creates an SSL socket with both client and context" do
      tcp_client = instance_double(DummyTCPSocket)
      allow(connection).to receive(:new_tcp_socket).and_return(tcp_client)
      allow(ssl_socket).to receive(:connect)

      expect(connection.ssl_socket_class).to receive(:new).with(tcp_client, instance_of(OpenSSL::SSL::SSLContext)).and_return(ssl_socket)
      connection.connect(request)
    end

    it "creates an SSLContext instance" do
      tcp_client = instance_double(DummyTCPSocket)
      allow(connection).to receive(:new_tcp_socket).and_return(tcp_client)

      context_received = nil
      allow(connection.ssl_socket_class).to receive(:new) do |client, context|
        context_received = context
        ssl_socket
      end
      allow(ssl_socket).to receive(:connect)

      connection.connect(request)
      expect(context_received).to be_a(OpenSSL::SSL::SSLContext)
    end

    it "calls connect on the SSL socket" do
      tcp_client = instance_double(DummyTCPSocket)
      allow(connection).to receive(:new_tcp_socket).and_return(tcp_client)
      allow(connection.ssl_socket_class).to receive(:new).and_return(ssl_socket)

      expect(ssl_socket).to receive(:connect)
      connection.connect(request)
    end

    it "returns the connected SSL socket" do
      tcp_client = instance_double(DummyTCPSocket)
      allow(connection).to receive(:new_tcp_socket).and_return(tcp_client)
      allow(connection.ssl_socket_class).to receive(:new).and_return(ssl_socket)
      allow(ssl_socket).to receive(:connect).and_return(ssl_socket)

      result = connection.connect(request)
      expect(result).to eq(ssl_socket)
    end

    it "passes the TCP client as first argument to SSLSocket" do
      tcp_client = instance_double(DummyTCPSocket)
      allow(connection).to receive(:new_tcp_socket).and_return(tcp_client)
      allow(ssl_socket).to receive(:connect)

      expect(connection.ssl_socket_class).to receive(:new).with(tcp_client, anything).and_return(ssl_socket)
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

  describe "#new_tcp_socket" do
    it "resolves the host before opening a TCP socket" do
      tcp_socket_class = double("tcp_socket_class")
      connection = described_class.new(tcp_socket_class:, ssl_socket_class: DummySSLSocket)

      expect(Resolv).to receive(:getaddress).with("stream.twitter.com").and_return("203.0.113.10")
      expect(tcp_socket_class).to receive(:new).with("203.0.113.10", 443)

      connection.send(:new_tcp_socket, "stream.twitter.com", 443)
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

    it "uses IO.select, reads 1024-byte chunks, and closes the client" do
      read_pipe = instance_double(IO)
      write_pipe = instance_double(IO)
      mocked_client = instance_double(TCPSocket)
      mocked_request = instance_double(HTTP::Request)
      mocked_response = double("response")

      expect(connection).to receive(:connect).with(mocked_request).and_return(mocked_client)
      expect(mocked_request).to receive(:stream).with(mocked_client)
      expect(IO).to receive(:pipe).and_return([read_pipe, write_pipe])
      expect(IO).to receive(:select).with([read_pipe, mocked_client]).ordered.and_return([[mocked_client], nil, nil])
      expect(IO).to receive(:select).with([read_pipe, mocked_client]).ordered.and_return([[read_pipe], nil, nil])
      expect(mocked_client).to receive(:readpartial).with(1024).and_return("test chunk")
      expect(mocked_response).to receive(:<<).with("test chunk")
      expect(mocked_client).to receive(:close)

      connection.stream(mocked_request, mocked_response)
    end

    it "ignores unknown readable IO objects and keeps looping" do
      read_pipe = instance_double(IO)
      write_pipe = instance_double(IO)
      unknown_io = instance_double(IO)
      mocked_client = instance_double(TCPSocket)
      mocked_request = instance_double(HTTP::Request)
      mocked_response = double("response")

      expect(connection).to receive(:connect).with(mocked_request).and_return(mocked_client)
      expect(mocked_request).to receive(:stream).with(mocked_client)
      expect(IO).to receive(:pipe).and_return([read_pipe, write_pipe])
      expect(IO).to receive(:select).with([read_pipe, mocked_client]).ordered.and_return([[unknown_io], nil, nil])
      expect(IO).to receive(:select).with([read_pipe, mocked_client]).ordered.and_return([[read_pipe], nil, nil])
      expect(mocked_client).not_to receive(:readpartial)
      expect(mocked_response).not_to receive(:<<)
      expect(mocked_client).to receive(:close)

      connection.stream(mocked_request, mocked_response)
    end
  end

end
