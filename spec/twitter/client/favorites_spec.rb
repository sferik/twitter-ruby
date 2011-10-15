require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe ".favorites" do
    context "with a screen name passed" do
      before do
        stub_get("/1/favorites/sferik.json").
          to_return(:body => fixture("favorites.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should get the correct resource" do
        @client.favorites("sferik")
        a_get("/1/favorites/sferik.json").
          should have_been_made
      end
      it "should return the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites("sferik")
        favorites.should be_an Array
        favorites.first.should be_an Twitter::Status
        favorites.first.user.name.should == "Zach Brock"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/favorites.json").
          to_return(:body => fixture("favorites.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should get the correct resource" do
        @client.favorites
        a_get("/1/favorites.json").
          should have_been_made
      end
      it "should return the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites
        favorites.should be_an Array
        favorites.first.should be_an Twitter::Status
        favorites.first.user.name.should == "Zach Brock"
      end
    end
  end

  describe ".favorite" do
    before do
      stub_post("/1/favorites/create/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should get the correct resource" do
      @client.favorite(25938088801)
      a_post("/1/favorites/create/25938088801.json").
        should have_been_made
    end
    it "should return the favorite status when successful" do
      status = @client.favorite(25938088801)
      status.should be_an Twitter::Status
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe ".unfavorite" do
    before do
      stub_delete("/1/favorites/destroy/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should get the correct resource" do
      @client.unfavorite(25938088801)
      a_delete("/1/favorites/destroy/25938088801.json").
        should have_been_made
    end
    it "should return the un-favorite status when successful" do
      status = @client.unfavorite(25938088801)
      status.should be_an Twitter::Status
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

end
