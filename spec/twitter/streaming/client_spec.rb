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

  it '#before_request' do
    @client.connection = FakeConnection.new(fixture('track_streaming.json'))
    var = false
    @client.before_request do
      var = true
    end
    expect(var).to be false
    @client.user {}
    expect(var).to be true
  end

  it '#filter' do
    @client.connection = FakeConnection.new(fixture('track_streaming.json'))
    objects = []
    @client.filter(:track => 'india') do |object|
      objects << object
    end
    expect(objects.size).to eq(2)
    expect(objects.first).to be_a Twitter::Tweet
    expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it '#firehose' do
    @client.connection = FakeConnection.new(fixture('track_streaming.json'))
    objects = []
    @client.firehose do |object|
      objects << object
    end
    expect(objects.size).to eq(2)
    expect(objects.first).to be_a Twitter::Tweet
    expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it '#sample' do
    @client.connection = FakeConnection.new(fixture('track_streaming.json'))
    objects = []
    @client.sample do |object|
      objects << object
    end
    expect(objects.size).to eq(2)
    expect(objects.first).to be_a Twitter::Tweet
    expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it '#site' do
    @client.connection = FakeConnection.new(fixture('track_streaming.json'))
    objects = []
    @client.site(7_505_382) do |object|
      objects << object
    end
    expect(objects.size).to eq(2)
    expect(objects.first).to be_a Twitter::Tweet
    expect(objects.first.text).to eq "The problem with your code is that it's doing exactly what you told it to do."
  end

  it '#user' do
    @client.connection = FakeConnection.new(fixture('track_streaming_user.json'))
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
    expect(objects[2].text).to eq('hello bot')
    expect(objects[3]).to be_a Twitter::Streaming::Event
    expect(objects[3].name).to eq(:follow)
    expect(objects[4]).to be_a Twitter::Streaming::DeletedTweet
    expect(objects[4].id).to eq(272_691_609_211_117_568)
    expect(objects[5]).to be_a Twitter::Streaming::StallWarning
    expect(objects[5].code).to eq('FALLING_BEHIND')
  end

end
