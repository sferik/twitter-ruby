require 'helper'

describe Twitter::Streaming::Client do
  before do
    @client = Twitter::Streaming::Client.new
  end

  class FakeConnection
    def initialize(body)
      @body = body
    end

    def stream(request, response)
      @body.each_line do |line|
        response.on_body(line)
      end
    end
  end

  it "#before_request" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    var = false
    @client.before_request do
      var = true
    end
    expect(var).to be false
    @client.user{}
    expect(var).to be true
  end

  it "#filter" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.filter(:track => "india") do |tweet|
      tweets << tweet
    end
    expect(tweets.size).to eq(2)
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#firehose" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.firehose do |tweet|
      tweets << tweet
    end
    expect(tweets.size).to eq(2)
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#sample" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.sample do |tweet|
      tweets << tweet
    end
    expect(tweets.size).to eq(2)
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#site" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.site(7505382) do |tweet|
      tweets << tweet
    end
    expect(tweets.size).to eq(2)
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#user" do
    @client.connection = FakeConnection.new(fixture("track_streaming_user.json"))
    items = []
    @client.user do |item|
      items << item
    end
    expect(items.size).to eq(5)
    expect(items[0]).to be_a Twitter::Streaming::FriendList
    expect(items[0].friend_ids).to eq([488736931,311444249])
    expect(items[1]).to be_a Twitter::Tweet
    expect(items[1].text).to eq "The problem with your code is that it's doing exactly what you told it to do."
    expect(items[3]).to be_a Twitter::DirectMessage
    expect(items[3].text).to eq "hello bot"
    expect(items[4]).to be_a Twitter::Streaming::Event
    expect(items[4].name).to be(:follow)
  end

end
