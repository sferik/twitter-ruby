require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".friend_ids" do

    context "with a screen_name passed" do

      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.friend_ids("sferik")
        a_get("/1/friends/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          should have_been_made
      end

      it "should return an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids("sferik")
        friend_ids.should be_a Twitter::Cursor
        friend_ids.ids.should be_an Array
        friend_ids.ids.first.should == 146197851
      end

    end

    context "without arguments passed" do

      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.friend_ids
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end

      it "should return an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids
        friend_ids.should be_a Twitter::Cursor
        friend_ids.ids.should be_an Array
        friend_ids.ids.first.should == 146197851
      end

    end

  end

  describe ".follower_ids" do

    context "with a screen_name passed" do

      before do
        stub_get("/1/followers/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.follower_ids("sferik")
        a_get("/1/followers/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          should have_been_made
      end

      it "should return an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids("sferik")
        follower_ids.should be_a Twitter::Cursor
        follower_ids.ids.should be_an Array
        follower_ids.ids.first.should == 146197851
      end

    end

    context "without arguments passed" do

      before do
        stub_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.follower_ids
        a_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end

      it "should return an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids
        follower_ids.should be_a Twitter::Cursor
        follower_ids.ids.should be_an Array
        follower_ids.ids.first.should == 146197851
      end
    end
  end
end
