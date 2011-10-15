require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe ".privacy" do
    before do
      stub_get("/1/legal/privacy.json").
        to_return(:body => fixture("privacy.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should get the correct resource" do
      @client.privacy
      a_get("/1/legal/privacy.json").
        should have_been_made
    end
    it "should return Twitter's Privacy Policy" do
      privacy = @client.privacy
      privacy.split.first.should == "Twitter"
    end
  end

  describe ".tos" do
    before do
      stub_get("/1/legal/tos.json").
        to_return(:body => fixture("tos.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should get the correct resource" do
      @client.tos
      a_get("/1/legal/tos.json").
        should have_been_made
    end
    it "should return Twitter's Terms of Service" do
      tos = @client.tos
      tos.split.first.should == "Terms"
    end
  end

end
