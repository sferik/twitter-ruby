require "helper"

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

describe Twitter::Streaming::Client do
  before do
    @client = described_class.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe "#initialize" do
    it "creates a connection with the provided options" do
      expect(Twitter::Streaming::Connection).to receive(:new).with(hash_including(tcp_socket_class: TCPSocket))
      described_class.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", tcp_socket_class: TCPSocket)
    end

    it "stores the connection" do
      client = described_class.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      expect(client.instance_variable_get(:@connection)).to be_a Twitter::Streaming::Connection
    end

    it "works with empty options hash" do
      # Pass options as empty hash (this tests that {} default works)
      expect(Twitter::Streaming::Connection).to receive(:new).with({})
      described_class.new({})
    end

    it "defaults options to an empty hash when called without arguments" do
      expect(Twitter::Streaming::Connection).to receive(:new).with({})
      described_class.new
    end

    it "uses Streaming::Connection explicitly even if Client::Connection exists" do
      stub_const("Twitter::Streaming::Client::Connection", Class.new do
        def self.new(*)
          raise "wrong constant"
        end
      end)

      expect { described_class.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS") }.not_to raise_error
    end
  end

  describe "#before_request" do
    it "runs before a request" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      var = false
      @client.before_request do
        var = true
      end
      expect(var).to be false
      @client.user {}
      expect(var).to be true
    end

    it "returns self when given a block for method chaining" do
      result = @client.before_request { }
      expect(result).to be @client
    end

    it "returns the stored proc when called without a block" do
      stored_proc = proc { "test" }
      @client.before_request(&stored_proc)
      expect(@client.before_request).to eq stored_proc
    end

    it "returns a no-op proc when no proc was stored" do
      result = @client.before_request
      expect(result).to be_a Proc
    end

    it "returns a no-op proc that accepts arbitrary arguments" do
      expect { @client.before_request.call(:unused_arg) }.not_to raise_error
    end
  end

  describe "#filter" do
    it "returns an arary of Tweets" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      objects = []
      @client.filter(track: "india") do |object|
        objects << object
      end
      expect(objects.size).to eq(2)
      expect(objects.first).to be_a Twitter::Tweet
      expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
    end

    it "passes options to the request" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(HTTP::Request).to receive(:new).with(hash_including(uri: %r{track=india}))
      @client.filter(track: "india") {}
    end

    it "works without options" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect { @client.filter {} }.not_to raise_error
    end
  end

  describe "#firehose" do
    it "returns an arary of Tweets" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      objects = []
      @client.firehose do |object|
        objects << object
      end
      expect(objects.size).to eq(2)
      expect(objects.first).to be_a Twitter::Tweet
      expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
    end

    it "passes options to the request" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(HTTP::Request).to receive(:new).with(hash_including(uri: %r{count=5}))
      @client.firehose(count: 5) {}
    end
  end

  describe "#sample" do
    it "returns an arary of Tweets" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      objects = []
      @client.sample do |object|
        objects << object
      end
      expect(objects.size).to eq(2)
      expect(objects.first).to be_a Twitter::Tweet
      expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
    end

    it "passes options to the request" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(HTTP::Request).to receive(:new).with(hash_including(uri: %r{stall_warnings=true}))
      @client.sample(stall_warnings: true) {}
    end

    it "does not yield when the message parser returns nil" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      allow(Twitter::Streaming::MessageParser).to receive(:parse).and_return(nil)
      yielded = []

      @client.sample { |object| yielded << object }

      expect(yielded).to be_empty
    end

    it "uses Streaming::MessageParser explicitly even if Client::MessageParser exists" do
      stub_const("Twitter::Streaming::Client::MessageParser", Class.new do
        def self.parse(*)
          raise "wrong constant"
        end
      end)

      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      objects = []

      expect { @client.sample { |object| objects << object } }.not_to raise_error
      expect(objects).not_to be_empty
    end
  end

  describe "#site" do
    context "with a user ID passed" do
      it "returns an arary of Tweets" do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        objects = []
        @client.site(7_505_382) do |object|
          objects << object
        end
        expect(objects.size).to eq(2)
        expect(objects.first).to be_a Twitter::Tweet
        expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
      end

      it "includes the user ID in the follow parameter" do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        expect(HTTP::Request).to receive(:new).with(hash_including(uri: %r{follow=7505382}))
        @client.site(7_505_382) {}
      end
    end

    context "with a user object passed" do
      it "returns an arary of Tweets" do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        objects = []
        user = Twitter::User.new(id: 7_505_382)
        @client.site(user) do |object|
          objects << object
        end
        expect(objects.size).to eq(2)
        expect(objects.first).to be_a Twitter::Tweet
        expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
      end

      it "extracts the user ID and includes it in the follow parameter" do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        user = Twitter::User.new(id: 7_505_382)
        expect(HTTP::Request).to receive(:new).with(hash_including(uri: %r{follow=7505382}))
        @client.site(user) {}
      end
    end

    context "with mixed user IDs and user objects" do
      it "extracts all user IDs correctly" do
        @client.connection = FakeConnection.new(fixture("track_streaming.json"))
        user = Twitter::User.new(id: 123)
        expect(HTTP::Request).to receive(:new).with(hash_including(uri: %r{follow=456%2C123}))
        @client.site(456, user) {}
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
      expect(objects.size).to eq(6)
      expect(objects[0]).to be_a Twitter::Streaming::FriendList
      expect(objects[0]).to eq([488_736_931, 311_444_249])
      expect(objects[1]).to be_a Twitter::Tweet
      expect(objects[1].text).to eq("The problem with your code is that it's doing exactly what you told it to do.")
      expect(objects[2]).to be_a Twitter::DirectMessage
      expect(objects[2].text).to eq("hello bot")
      expect(objects[3]).to be_a Twitter::Streaming::Event
      expect(objects[3].name).to eq(:follow)
      expect(objects[4]).to be_a Twitter::Streaming::DeletedTweet
      expect(objects[4].id).to eq(272_691_609_211_117_568)
      expect(objects[5]).to be_a Twitter::Streaming::StallWarning
      expect(objects[5].code).to eq("FALLING_BEHIND")
    end

    it "passes options to the request" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(HTTP::Request).to receive(:new).with(hash_including(uri: %r{track=test}))
      @client.user(track: "test") {}
    end
  end

  context "when using a proxy" do
    let(:proxy) { {host: "127.0.0.1", port: 3328} }

    before do
      @client = described_class.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", proxy:)
    end

    it "requests via the proxy" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(HTTP::Request).to receive(:new).with(verb: :get, uri: "https://stream.twitter.com:443/1.1/statuses/sample.json?", headers: kind_of(Hash), proxy:)
      @client.sample {}
    end
  end

  describe "request header generation" do
    it "passes method to Headers" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(Twitter::Headers).to receive(:new).with(@client, :get, anything, anything).and_call_original
      @client.sample {}
    end

    it "passes uri to Headers" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(Twitter::Headers).to receive(:new).with(@client, anything, %r{statuses/sample\.json}, anything).and_call_original
      @client.sample {}
    end

    it "passes params to Headers" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      expect(Twitter::Headers).to receive(:new).with(@client, anything, anything, {track: "test"}).and_call_original
      @client.filter(track: "test") {}
    end

    it "generates valid OAuth headers" do
      @client.connection = FakeConnection.new(fixture("track_streaming.json"))
      headers_received = nil
      allow(HTTP::Request).to receive(:new) do |args|
        headers_received = args[:headers]
        instance_double(HTTP::Request, verb: args[:verb], uri: args[:uri], stream: nil)
      end
      @client.sample {}
      expect(headers_received).to have_key(:authorization)
      expect(headers_received[:authorization]).to include("OAuth")
    end
  end

  describe "#close" do
    it "closes the connection" do
      connection = instance_double(Twitter::Streaming::Connection)
      @client.connection = connection
      expect(connection).to receive(:close)
      @client.close
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
      stub_const("Twitter::Streaming::Client::User", shadow_user_class)

      result = @client.send(:collect_user_ids, [shadow_user_class.new(123), Twitter::User.new(id: 456)])
      expect(result).to eq([456])
    end
  end

  describe "#request (private)" do
    let(:uri) { "https://stream.twitter.com:443/1.1/statuses/sample.json" }
    let(:request_object) { instance_double(HTTP::Request) }
    let(:response_object) { instance_double(Twitter::Streaming::Response) }
    let(:connection) { instance_double(Twitter::Streaming::Connection) }

    before do
      @client.connection = connection
      allow(Twitter::Headers).to receive_message_chain(:new, :request_headers).and_return({})
      allow(HTTP::Request).to receive(:new).and_return(request_object)
      allow(Twitter::Streaming::Response).to receive(:new).and_return(response_object)
      allow(Twitter::Streaming::MessageParser).to receive(:parse).and_return(nil)
      allow(connection).to receive(:stream)
    end

    it "passes the built request object to the connection" do
      expect(connection).to receive(:stream).with(request_object, response_object)
      @client.send(:request, :get, uri, {}) {}
    end

    it "uses Twitter::Headers explicitly even if Client::Headers exists" do
      stub_const("Twitter::Streaming::Client::Headers", Class.new do
        def self.new(*)
          raise "wrong constant"
        end
      end)

      expect { @client.send(:request, :get, uri, {}) {} }.not_to raise_error
    end

    it "uses Streaming::Response explicitly even if Client::Response exists" do
      stub_const("Twitter::Streaming::Client::Response", Class.new do
        def self.new(*)
          raise "wrong constant"
        end
      end)

      expect { @client.send(:request, :get, uri, {}) {} }.not_to raise_error
    end

    it "uses Streaming::MessageParser explicitly even if Client::MessageParser exists" do
      stub_const("Twitter::Streaming::Client::MessageParser", Class.new do
        def self.parse(*)
          raise "wrong constant"
        end
      end)

      expect { @client.send(:request, :get, uri, {}) {} }.not_to raise_error
    end
  end
end
