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
    expect(var).to be_false
    @client.user{}
    expect(var).to be_true
  end

  it "#filter" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.filter(:track => "india") do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#firehose" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.firehose do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#sample" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.sample do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#site" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.site(7505382) do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "#user" do
    @client.connection = FakeConnection.new(fixture("track_streaming_user.json"))
    items = []
    @client.user do |item|
      items << item
    end
    expect(items).to have(3).entries
    expect(items.first).to be_a Twitter::Tweet
    expect(items.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
    expect(items[2]).to be_a Twitter::DirectMessage
    expect(items[2].text).to eq "hello bot"
  end

end
