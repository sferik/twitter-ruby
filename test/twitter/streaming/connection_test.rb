require "test_helper"

DummyTCPSocket = Class.new

class DummySSLSocket
  def connect
  end
end

class DummyResponse
  def initialize
    yield if block_given?
  end

  def <<(_data)
  end
end

describe Twitter::Streaming::Connection do
  describe "initialize" do
    describe "no options provided" do
      let(:connection) { Twitter::Streaming::Connection.new }

      it "sets the default socket classes" do
        assert_equal(TCPSocket, connection.tcp_socket_class)
        assert_equal(OpenSSL::SSL::SSLSocket, connection.ssl_socket_class)
      end
    end

    describe "custom socket classes provided in opts" do
      let(:connection) do
        Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
      end

      it "sets the default socket classes" do
        assert_equal(DummyTCPSocket, connection.tcp_socket_class)
        assert_equal(DummySSLSocket, connection.ssl_socket_class)
      end
    end
  end

  describe "connection" do
    let(:connection) do
      Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    let(:http_method) { :get }
    let(:uri) { "https://stream.twitter.com:443/1.1/statuses/sample.json" }
    let(:request) { HTTP::Request.new(verb: http_method, uri:) }

    it "opens a TCP socket to the request host and port" do
      tcp_args = nil
      connect_called = false
      ssl_socket = Object.new
      ssl_socket.define_singleton_method(:connect) { connect_called = true }

      connection.stub(:new_tcp_socket, lambda { |host, port|
        tcp_args = [host, port]
        Object.new
      }) do
        connection.ssl_socket_class.stub(:new, ->(_client, _context) { ssl_socket }) do
          connection.connect(request)
        end
      end

      assert_equal(["stream.twitter.com", 443], tcp_args)
      assert(connect_called)
    end

    it "creates an SSL socket with both client and context" do
      tcp_client = Object.new
      ssl_new_args = nil
      ssl_socket = Object.new
      ssl_socket.define_singleton_method(:connect) { nil }

      connection.stub(:new_tcp_socket, ->(_host, _port) { tcp_client }) do
        connection.ssl_socket_class.stub(:new, lambda { |*args|
          ssl_new_args = args
          ssl_socket
        }) do
          connection.connect(request)
        end
      end

      assert_equal(tcp_client, ssl_new_args[0])
      assert_kind_of(OpenSSL::SSL::SSLContext, ssl_new_args[1])
    end

    it "creates an SSLContext instance" do
      tcp_client = Object.new
      context_received = nil
      ssl_socket = Object.new
      ssl_socket.define_singleton_method(:connect) { nil }

      connection.stub(:new_tcp_socket, ->(_host, _port) { tcp_client }) do
        connection.ssl_socket_class.stub(:new, lambda { |_client, context|
          context_received = context
          ssl_socket
        }) do
          connection.connect(request)
        end
      end

      assert_kind_of(OpenSSL::SSL::SSLContext, context_received)
    end

    it "calls connect on the SSL socket" do
      connect_called = false
      ssl_socket = Object.new
      ssl_socket.define_singleton_method(:connect) { connect_called = true }

      connection.stub(:new_tcp_socket, ->(_host, _port) { Object.new }) do
        connection.ssl_socket_class.stub(:new, ->(_client, _context) { ssl_socket }) do
          connection.connect(request)
        end
      end

      assert(connect_called)
    end

    it "returns the value from SSL socket connect" do
      ssl_socket = Object.new
      ssl_socket.define_singleton_method(:connect) { :connected_ssl_socket }

      result = nil
      connection.stub(:new_tcp_socket, ->(_host, _port) { Object.new }) do
        connection.ssl_socket_class.stub(:new, ->(_client, _context) { ssl_socket }) do
          result = connection.connect(request)
        end
      end

      assert_equal(:connected_ssl_socket, result)
    end

    it "passes the TCP client as first argument to SSLSocket" do
      tcp_client = Object.new
      first_ssl_arg = nil
      ssl_socket = Object.new
      ssl_socket.define_singleton_method(:connect) { nil }

      connection.stub(:new_tcp_socket, ->(_host, _port) { tcp_client }) do
        connection.ssl_socket_class.stub(:new, lambda { |client, _context|
          first_ssl_arg = client
          ssl_socket
        }) do
          connection.connect(request)
        end
      end

      assert_equal(tcp_client, first_ssl_arg)
    end

    describe "when using a proxy" do
      let(:proxy) { {proxy_address: "127.0.0.1", proxy_port: 3328} }
      let(:request) { HTTP::Request.new(verb: http_method, uri:, proxy:) }

      it "requests via the proxy" do
        tcp_args = nil
        tcp_client = Object.new

        connection.stub(:new_tcp_socket, lambda { |host, port|
          tcp_args = [host, port]
          tcp_client
        }) do
          result = connection.connect(request)

          assert_equal(tcp_client, result)
        end

        assert_equal(["127.0.0.1", 3328], tcp_args)
      end

      it "creates a real TCP socket when connecting via proxy without SSL" do
        server = TCPServer.new("::", 0)
        port = server.addr[1]
        proxy_opts = {proxy_address: "localhost", proxy_port: port}
        proxy_request = HTTP::Request.new(verb: http_method, uri:, proxy: proxy_opts)

        connection_instance = Twitter::Streaming::Connection.new(tcp_socket_class: TCPSocket, ssl_socket_class: DummySSLSocket, using_ssl: false)

        accepted_socket = nil
        thread = Thread.start { accepted_socket = server.accept }

        client = connection_instance.connect(proxy_request)
        thread.join

        assert_kind_of(TCPSocket, client)
        refute_nil(accepted_socket)

        client.close
        accepted_socket&.close
        server.close
      end

      describe "if using ssl" do
        let(:connection) do
          Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket, using_ssl: true)
        end

        it "connects with ssl" do
          tcp_args = nil
          ssl_new_called = false
          ssl_connect_called = false
          ssl_socket = Object.new
          ssl_socket.define_singleton_method(:connect) { ssl_connect_called = true }

          connection.stub(:new_tcp_socket, lambda { |host, port|
            tcp_args = [host, port]
            Object.new
          }) do
            connection.ssl_socket_class.stub(:new, lambda { |_client, _context|
              ssl_new_called = true
              ssl_socket
            }) do
              connection.connect(request)
            end
          end

          assert_equal(["127.0.0.1", 3328], tcp_args)
          assert(ssl_new_called)
          assert(ssl_connect_called)
        end
      end
    end
  end

  describe "#close" do
    let(:connection) do
      Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    it "does nothing when write_pipe is nil" do
      assert_nothing_raised { connection.close }
    end
  end

  describe "#new_tcp_socket" do
    it "resolves the host before opening a TCP socket" do
      tcp_socket_class = Class.new do
        class << self
          attr_accessor :new_args
        end

        def self.new(host, port)
          self.new_args = [host, port]
          :socket
        end
      end
      connection = Twitter::Streaming::Connection.new(tcp_socket_class:, ssl_socket_class: DummySSLSocket)

      resolved_host = nil
      Resolv.stub(:getaddress, lambda { |host|
        resolved_host = host
        "203.0.113.10"
      }) do
        connection.send(:new_tcp_socket, "stream.twitter.com", 443)
      end

      assert_equal("stream.twitter.com", resolved_host)
      assert_equal(["203.0.113.10", 443], tcp_socket_class.new_args)
    end
  end

  describe "stream" do
    let(:connection) do
      Twitter::Streaming::Connection.new(tcp_socket_class: DummyTCPSocket, ssl_socket_class: DummySSLSocket)
    end

    let(:http_method) { :get }
    let(:uri) { "https://stream.twitter.com:443/1.1/statuses/sample.json" }
    let(:client) { TCPSocket.new("127.0.0.1", @server.addr[1]) }

    let(:request) { HTTP::Request.new(verb: http_method, uri:) }
    let(:response) { DummyResponse.new {} }

    before do
      @server = TCPServer.new("127.0.0.1", 0)
    end

    after do
      @server.close
    end

    it "closes stream" do
      connect_args = []
      request_stream_args = []
      request.define_singleton_method(:stream) { |socket| request_stream_args << socket }

      connection.stub(:connect, lambda { |incoming_request|
        connect_args << incoming_request
        client
      }) do
        stream_closed = false
        thread = Thread.start do
          connection.stream(request, response)
          stream_closed = true
        end

        refute(stream_closed)
        sleep 1
        connection.close
        thread.join

        assert(stream_closed)
      end

      assert_equal([request], connect_args)
      assert_equal([client], request_stream_args)
    end

    it "reads data from the client and passes it to the response" do
      received_data = []
      response_with_capture_class = Class.new do
        define_method(:initialize) { @received = received_data }
        define_method(:<<) { |data| @received << data }
      end
      response_with_capture = response_with_capture_class.new {}

      request_stream_args = []
      request.define_singleton_method(:stream) { |socket| request_stream_args << socket }

      connection.stub(:connect, ->(_incoming_request) { client }) do
        thread = Thread.start do
          connection.stream(request, response_with_capture)
        end

        server_client = @server.accept
        server_client.write("test data")
        server_client.flush

        sleep 0.1

        connection.close
        thread.join
        server_client.close
      end

      assert_equal([client], request_stream_args)
      assert_includes(received_data, "test data")
    end

    it "uses IO.select, reads 1024-byte chunks, and closes the client" do
      read_pipe = Object.new
      write_pipe = Object.new
      mocked_client = Object.new
      mocked_request = Object.new
      mocked_response = Object.new

      streamed_client = nil
      mocked_request.define_singleton_method(:stream) { |client_arg| streamed_client = client_arg }

      read_sizes = []
      mocked_client.define_singleton_method(:readpartial) do |size|
        read_sizes << size
        "test chunk"
      end

      received_chunks = []
      mocked_response.define_singleton_method(:<<) { |chunk| received_chunks << chunk }

      client_closed = false
      mocked_client.define_singleton_method(:close) { client_closed = true }

      select_args = []
      select_returns = [
        [[mocked_client], nil, nil],
        [[read_pipe], nil, nil]
      ]

      connection.stub(:connect, lambda { |request_arg|
        assert_equal(mocked_request, request_arg)
        mocked_client
      }) do
        IO.stub(:pipe, [read_pipe, write_pipe]) do
          IO.stub(:select, lambda { |readables|
            select_args << readables
            select_returns.shift
          }) do
            connection.stream(mocked_request, mocked_response)
          end
        end
      end

      assert_equal(mocked_client, streamed_client)
      assert_equal([[read_pipe, mocked_client], [read_pipe, mocked_client]], select_args)
      assert_equal([1024], read_sizes)
      assert_equal(["test chunk"], received_chunks)
      assert(client_closed)
    end

    it "ignores unknown readable IO objects and keeps looping" do
      read_pipe = Object.new
      write_pipe = Object.new
      unknown_io = Object.new
      mocked_client = Object.new
      mocked_request = Object.new
      mocked_response = Object.new

      mocked_request.define_singleton_method(:stream) { |_client_arg| nil }

      mocked_client.define_singleton_method(:readpartial) { |_size| flunk("readpartial should not be called") }
      mocked_response.define_singleton_method(:<<) { |_chunk| flunk("response append should not be called") }

      client_closed = false
      mocked_client.define_singleton_method(:close) { client_closed = true }

      select_returns = [
        [[unknown_io], nil, nil],
        [[read_pipe], nil, nil]
      ]

      connection.stub(:connect, ->(_request_arg) { mocked_client }) do
        IO.stub(:pipe, [read_pipe, write_pipe]) do
          IO.stub(:select, ->(_readables) { select_returns.shift }) do
            connection.stream(mocked_request, mocked_response)
          end
        end
      end

      assert(client_closed)
    end
  end
end
