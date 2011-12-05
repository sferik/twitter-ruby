require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe ".enable_notifications" do
    before do
      stub_post("/1/notifications/follow.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.enable_notifications("sferik")
      a_post("/1/notifications/follow.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "should return the specified user when successful" do
      user = @client.enable_notifications("sferik")
      user.should be_a Twitter::User
      user.name.should == "Erik Michaels-Ober"
    end
  end

  describe ".disable_notifications" do
    before do
      stub_post("/1/notifications/leave.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.disable_notifications("sferik")
      a_post("/1/notifications/leave.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "should return the specified user when successful" do
      user = @client.disable_notifications("sferik")
      user.should be_a Twitter::User
      user.name.should == "Erik Michaels-Ober"
    end
  end

end
