require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#enable_notifications" do
    before do
      stub_post("/1/notifications/follow.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.enable_notifications("sferik")
      a_post("/1/notifications/follow.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns an array of users" do
      users = @client.enable_notifications("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#disable_notifications" do
    before do
      stub_post("/1/notifications/leave.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.disable_notifications("sferik")
      a_post("/1/notifications/leave.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns an array of users" do
      users = @client.disable_notifications("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

end
