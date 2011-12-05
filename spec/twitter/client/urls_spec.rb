require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".resolve" do

    before do
      stub_get("/1/urls/resolve.json").
        with(:query => {:urls => ["http://t.co/uw5bn1w"]}).
        to_return(:body => fixture("resolve.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should request the correct resource" do
      @client.resolve('http://t.co/uw5bn1w')
      a_get("/1/urls/resolve.json").
        with(:query => {:urls => ["http://t.co/uw5bn1w"]}).
        with(:headers => {'X-Phx' => 'true'}).
        should have_been_made
    end

    it "should return the canonical version of a URL shortened by Twitter" do
      resolve = @client.resolve('http://t.co/uw5bn1w')
      resolve.should be_a Hash
      resolve["http://t.co/uw5bn1w"].should == "http://www.jeanniejeannie.com/2011/08/29/the-art-of-clean-up-sorting-and-stacking-everyday-objects/"
    end

  end
end
