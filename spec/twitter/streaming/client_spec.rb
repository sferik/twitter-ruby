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

  it "supports tracking keywords" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.filter(:track => "india") do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "supports firehose" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.firehose do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "supports sample" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.sample do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "supports site streams" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.site(7505382) do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it "supports user streams" do
    @client.connection = FakeConnection.new(fixture("track_streaming.json"))
    tweets = []
    @client.user do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
    expect(tweets.first).to be_a Twitter::Tweet
    expect(tweets.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

end
