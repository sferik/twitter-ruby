require "test_helper"

class FakeConnection
  def initialize(body)
    @body = body
  end

  def stream(_request, response)
    @body.each_line do |line|
      response.on_body(line)
    end
  end
end

class CapturingConnection
  attr_reader :request, :response

  def stream(request, response)
    @request = request
    @response = response
  end

  def close
    @closed = true
  end

  def closed?
    @closed
  end
end

describe Twitter::Streaming::Client do
  before do
    @client = build_streaming_client
  end

  describe "#initialize" do
    it "creates a connection with the provided options" do
      captured_options = nil
      connection_instance = Object.new

      Twitter::Streaming::Connection.stub(:new, lambda { |options|
        captured_options = options
        connection_instance
      }) do
        build_streaming_client(tcp_socket_class: TCPSocket)
      end

      assert_equal(TCPSocket, captured_options[:tcp_socket_class])
    end

    it "stores the connection" do
      client = build_streaming_client

      assert_kind_of(Twitter::Streaming::Connection, client.instance_variable_get(:@connection))
    end

    it "works with empty options hash" do
      captured_options = nil

      Twitter::Streaming::Connection.stub(:new, lambda { |options|
        captured_options = options
        Object.new
      }) do
        Twitter::Streaming::Client.new({})
      end

      assert_empty(captured_options)
    end

    it "defaults options to an empty hash when called without arguments" do
      captured_options = nil

      Twitter::Streaming::Connection.stub(:new, lambda { |options|
        captured_options = options
        Object.new
      }) do
        Twitter::Streaming::Client.new
      end

      assert_empty(captured_options)
    end

    it "uses Streaming::Connection explicitly even if Client::Connection exists" do
      with_stubbed_const("Twitter::Streaming::Client::Connection", Class.new do
        def self.new(*)
          raise "wrong constant"
        end
      end) do
        assert_nothing_raised do
          build_streaming_client
        end
      end
    end
  end

  describe "#before_request" do
    it "runs before a request" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      var = false
      @client.before_request do
        var = true
      end

      refute(var)
      @client.user {}

      assert(var)
    end

    it "returns self when given a block for method chaining" do
      result = @client.before_request {}

      assert_operator(@client, :equal?, result)
    end

    it "returns the stored proc when called without a block" do
      stored_proc = proc { "test" }
      @client.before_request(&stored_proc)

      assert_equal(stored_proc, @client.before_request)
    end

    it "returns a no-op proc when no proc was stored" do
      result = @client.before_request

      assert_kind_of(Proc, result)
    end

    it "returns a no-op proc that accepts arbitrary arguments" do
      assert_nothing_raised { @client.before_request.call(:unused_arg) }
    end
  end

  describe "#filter" do
    it "returns an arary of Tweets" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      objects = []
      @client.filter(track: "india") do |object|
        objects << object
      end

      assert_equal(2, objects.size)
      assert_kind_of(Twitter::Tweet, objects.first)
      assert_equal("The problem with your code is that it's doing exactly what you told it to do.", objects.first.text)
    end

    it "passes options to the request" do
      connection = CapturingConnection.new
      @client.connection = connection

      @client.filter(track: "india") {}

      assert_match(/track=india/, connection.request.uri.to_s)
    end

    it "works without options" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      assert_nothing_raised { @client.filter {} }
    end
  end

  describe "#firehose" do
    it "returns an arary of Tweets" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      objects = []
      @client.firehose do |object|
        objects << object
      end

      assert_equal(2, objects.size)
      assert_kind_of(Twitter::Tweet, objects.first)
      assert_equal("The problem with your code is that it's doing exactly what you told it to do.", objects.first.text)
    end

    it "passes options to the request" do
      connection = CapturingConnection.new
      @client.connection = connection

      @client.firehose(count: 5) {}

      assert_match(/count=5/, connection.request.uri.to_s)
    end
  end

  describe "#sample" do
    it "returns an arary of Tweets" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      objects = []
      @client.sample do |object|
        objects << object
      end

      assert_equal(2, objects.size)
      assert_kind_of(Twitter::Tweet, objects.first)
      assert_equal("The problem with your code is that it's doing exactly what you told it to do.", objects.first.text)
    end

    it "passes options to the request" do
      connection = CapturingConnection.new
      @client.connection = connection

      @client.sample(stall_warnings: true) {}

      assert_match(/stall_warnings=true/, connection.request.uri.to_s)
    end

    it "does not yield when the message parser returns nil" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      yielded = []

      Twitter::Streaming::MessageParser.stub(:parse, nil) do
        @client.sample { |object| yielded << object }
      end

      assert_empty(yielded)
    end

    it "uses Streaming::MessageParser explicitly even if Client::MessageParser exists" do
      with_stubbed_const("Twitter::Streaming::Client::MessageParser", Class.new do
        def self.parse(*)
          raise "wrong constant"
        end
      end) do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        objects = []

        assert_nothing_raised { @client.sample { |object| objects << object } }
        refute_empty(objects)
      end
    end
  end

  describe "#site" do
    describe "with a user ID passed" do
      it "returns an arary of Tweets" do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        objects = []
        @client.site(7_505_382) do |object|
          objects << object
        end

        assert_equal(2, objects.size)
        assert_kind_of(Twitter::Tweet, objects.first)
        assert_equal("The problem with your code is that it's doing exactly what you told it to do.", objects.first.text)
      end

      it "includes the user ID in the follow parameter" do
        connection = CapturingConnection.new
        @client.connection = connection

        @client.site(7_505_382) {}

        assert_match(/follow=7505382/, connection.request.uri.to_s)
      end
    end

    describe "with a user object passed" do
      it "returns an arary of Tweets" do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        objects = []
        user = Twitter::User.new(id: 7_505_382)
        @client.site(user) do |object|
          objects << object
        end

        assert_equal(2, objects.size)
        assert_kind_of(Twitter::Tweet, objects.first)
        assert_equal("The problem with your code is that it's doing exactly what you told it to do.", objects.first.text)
      end

      it "extracts the user ID and includes it in the follow parameter" do
        connection = CapturingConnection.new
        @client.connection = connection
        user = Twitter::User.new(id: 7_505_382)

        @client.site(user) {}

        assert_match(/follow=7505382/, connection.request.uri.to_s)
      end
    end

    describe "with mixed user IDs and user objects" do
      it "extracts all user IDs correctly" do
        connection = CapturingConnection.new
        @client.connection = connection
        user = Twitter::User.new(id: 123)

        @client.site(456, user) {}

        assert_match(/follow=456%2C123/, connection.request.uri.to_s)
      end
    end
  end

  describe "#user" do
    it "returns an arary of Tweets" do
      @client.connection = FakeConnection.new(fixture("track_streaming_user.json"))
      objects = []
      @client.user do |object|
        objects << object
      end

      assert_equal(6, objects.size)
      assert_kind_of(Twitter::Streaming::FriendList, objects[0])
      assert_equal([488_736_931, 311_444_249], objects[0])
      assert_kind_of(Twitter::Tweet, objects[1])
      assert_equal("The problem with your code is that it's doing exactly what you told it to do.", objects[1].text)
      assert_kind_of(Twitter::DirectMessage, objects[2])
      assert_equal("hello bot", objects[2].text)
      assert_kind_of(Twitter::Streaming::Event, objects[3])
      assert_equal(:follow, objects[3].name)
      assert_kind_of(Twitter::Streaming::DeletedTweet, objects[4])
      assert_equal(272_691_609_211_117_568, objects[4].id)
      assert_kind_of(Twitter::Streaming::StallWarning, objects[5])
      assert_equal("FALLING_BEHIND", objects[5].code)
    end

    it "passes options to the request" do
      connection = CapturingConnection.new
      @client.connection = connection

      @client.user(track: "test") {}

      assert_match(/track=test/, connection.request.uri.to_s)
    end
  end

  describe "when using a proxy" do
    let(:proxy) { {host: "127.0.0.1", port: 3328} }

    before do
      @client = build_streaming_client(proxy:)
    end

    it "requests via the proxy" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      request_args = nil
      dummy_request = Object.new
      dummy_request.define_singleton_method(:stream) { |_client| nil }

      HTTP::Request.stub(:new, lambda { |args|
        request_args = args
        dummy_request
      }) do
        @client.sample {}
      end

      assert_equal(:get, request_args[:verb])
      assert_equal("https://stream.twitter.com:443/1.1/statuses/sample.json?", request_args[:uri])
      assert_kind_of(Hash, request_args[:headers])
      assert_equal(proxy, request_args[:proxy])
    end
  end

  describe "request header generation" do
    it "passes method to Headers" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      captured_args = nil
      original_new = Twitter::Headers.method(:new)

      Twitter::Headers.stub(:new, lambda { |*args|
        captured_args = args
        original_new.call(*args)
      }) do
        @client.sample {}
      end

      assert_equal(@client, captured_args[0])
      assert_equal(:get, captured_args[1])
    end

    it "passes uri to Headers" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      captured_args = nil
      original_new = Twitter::Headers.method(:new)

      Twitter::Headers.stub(:new, lambda { |*args|
        captured_args = args
        original_new.call(*args)
      }) do
        @client.sample {}
      end

      assert_match(%r{statuses/sample\.json}, captured_args[2].to_s)
    end

    it "passes params to Headers" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      captured_args = nil
      original_new = Twitter::Headers.method(:new)

      Twitter::Headers.stub(:new, lambda { |*args|
        captured_args = args
        original_new.call(*args)
      }) do
        @client.filter(track: "test") {}
      end

      assert_equal({track: "test"}, captured_args[3])
    end

    it "generates valid OAuth headers" do
      connection = CapturingConnection.new
      @client.connection = connection

      @client.sample {}

      headers_received = connection.request.headers
      authorization = headers_received["Authorization"] || headers_received[:authorization]

      refute_nil(authorization)
      assert_includes(authorization, "OAuth")
    end
  end

  describe "#close" do
    it "closes the connection" do
      close_called = false
      connection = Object.new
      connection.define_singleton_method(:close) { close_called = true }
      @client.connection = connection

      @client.close

      assert(close_called)
    end
  end

  describe "#collect_user_ids (private)" do
    it "matches Twitter::User explicitly even when Client::User exists" do
      shadow_user_class = Class.new do
        attr_reader :id

        def initialize(id)
          @id = id
        end
      end

      with_stubbed_const("Twitter::Streaming::Client::User", shadow_user_class) do
        result = @client.send(:collect_user_ids, [shadow_user_class.new(123), Twitter::User.new(id: 456)])

        assert_equal([456], result)
      end
    end
  end

  describe "#request (private)" do
    let(:uri) { "https://stream.twitter.com:443/1.1/statuses/sample.json" }

    it "passes the built request object to the connection" do
      request_object = Object.new
      response_object = Object.new
      stream_args = nil
      connection = Object.new
      connection.define_singleton_method(:stream) { |request, response| stream_args = [request, response] }
      @client.connection = connection

      header_builder = Object.new
      header_builder.define_singleton_method(:request_headers) { {} }

      Twitter::Headers.stub(:new, ->(_client, _method, _uri, _params) { header_builder }) do
        HTTP::Request.stub(:new, ->(_args) { request_object }) do
          Twitter::Streaming::Response.stub(:new, ->(&_block) { response_object }) do
            Twitter::Streaming::MessageParser.stub(:parse, nil) do
              @client.send(:request, :get, uri, {}) {}
            end
          end
        end
      end

      assert_equal([request_object, response_object], stream_args)
    end

    it "uses Twitter::Headers explicitly even if Client::Headers exists" do
      with_stubbed_const("Twitter::Streaming::Client::Headers", Class.new do
        def self.new(*)
          raise "wrong constant"
        end
      end) do
        @client.connection = CapturingConnection.new
        assert_nothing_raised { @client.send(:request, :get, uri, {}) {} }
      end
    end

    it "uses Streaming::Response explicitly even if Client::Response exists" do
      with_stubbed_const("Twitter::Streaming::Client::Response", Class.new do
        def self.new(*)
          raise "wrong constant"
        end
      end) do
        @client.connection = CapturingConnection.new
        assert_nothing_raised { @client.send(:request, :get, uri, {}) {} }
      end
    end

    it "uses Streaming::MessageParser explicitly even if Client::MessageParser exists" do
      with_stubbed_const("Twitter::Streaming::Client::MessageParser", Class.new do
        def self.parse(*)
          raise "wrong constant"
        end
      end) do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        yielded = []

        assert_nothing_raised { @client.send(:request, :get, uri, {}) { |item| yielded << item } }
        refute_empty(yielded)
      end
    end
  end
end
