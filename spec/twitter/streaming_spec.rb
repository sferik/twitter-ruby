require 'helper'

describe Twitter::Streaming do
  before do
    @client = Twitter::Client.new
  end

  class FakeConnection
    include Celluloid::IO
    def initialize(body)
      @body = body
    end

    def stream(request, response)
      # TODO: assert request is valid
      @body.each_line do |line|
        response.on_body(line)
      end
    end
  end

  it "supports tracking keywords" do
    @client.stream.connection = FakeConnection.new(fixture("track_streaming.json"))

    tweets = []
    @client.stream.track("india") do |tweet|
      tweets << tweet
    end
    expect(tweets).to have(2).entries
  end
end
