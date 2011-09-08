=begin
require 'helper'

describe Twitter::Client do
  context ".new" do
    before do
      @client = Twitter::Client.new
    end

    describe ".about_me" do

      before do
        stub_get("i/activity/about_me.json").
          to_return(:body => fixture("about_me.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.about_me
        a_get("i/activity/about_me.json").
          with(:headers => {'X-Phx' => 'true'}).
          should have_been_made
      end

      it "should return activity about me" do
        about_me = @client.about_me
        about_me.first.action.should == "mention"
      end

    end

    describe ".by_friends" do

      before do
        stub_get("i/activity/by_friends.json").
          to_return(:body => fixture("by_friends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.by_friends
        a_get("i/activity/by_friends.json").
          with(:headers => {'X-Phx' => 'true'}).
          should have_been_made
      end

      it "should return activity by friends" do
        by_friends = @client.by_friends
        by_friends.first.action.should == "favorite"
      end

    end
  end
end
=end
