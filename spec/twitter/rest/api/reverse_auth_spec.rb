require 'helper'

describe Twitter::REST::API::ReverseAuth do

  describe "#token" do
    #TODO MOCK ALL THE THINGS
    it "requests the correct resource" do
        WebMock.disable!
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        end
        pp client.reverse_token
    end

  end

end
