require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#home_timeline" do
    before do
      stub_get("/1/statuses/home_timeline.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.home_timeline
      a_get("/1/statuses/home_timeline.json").
        should have_been_made
    end
    it "returns the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the user's they follow" do
      statuses = @client.home_timeline
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#mentions" do
    before do
      stub_get("/1/statuses/mentions.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.mentions
      a_get("/1/statuses/mentions.json").
        should have_been_made
    end
    it "returns the 20 most recent mentions (status containing @username) for the authenticating user" do
      statuses = @client.mentions
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#retweeted_by" do
    context "with a screen name passed" do
      before do
        stub_get("/1/statuses/retweeted_by_user.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeted_by("sferik")
        a_get("/1/statuses/retweeted_by_user.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent retweets posted by the authenticating user" do
        statuses = @client.retweeted_by("sferik")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/statuses/retweeted_by_me.json").
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeted_by
        a_get("/1/statuses/retweeted_by_me.json").
          should have_been_made
      end
    end
  end

  describe "#retweeted_to" do
    context "with a screen name passed" do
      before do
        stub_get("/1/statuses/retweeted_to_user.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeted_to("sferik")
        a_get("/1/statuses/retweeted_to_user.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent retweets posted by users the authenticating user follow" do
        statuses = @client.retweeted_to("sferik")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/statuses/retweeted_to_me.json").
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeted_to
        a_get("/1/statuses/retweeted_to_me.json").
          should have_been_made
      end
    end
  end

  describe "#retweets_of_me" do
    before do
      stub_get("/1/statuses/retweets_of_me.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweets_of_me
      a_get("/1/statuses/retweets_of_me.json").
        should have_been_made
    end
    it "returns the 20 most recent tweets of the authenticated user that have been retweeted by others" do
      statuses = @client.retweets_of_me
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#user_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1/statuses/user_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline("sferik")
        a_get("/1/statuses/user_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent statuses posted by the user specified by screen name or user id" do
        statuses = @client.user_timeline("sferik")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/statuses/user_timeline.json").
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline
        a_get("/1/statuses/user_timeline.json").
          should have_been_made
      end
    end
  end

  describe "#media_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1/statuses/media_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("media_timeline.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.media_timeline("sferik")
        a_get("/1/statuses/media_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent images posted by the user specified by screen name or user id" do
        statuses = @client.media_timeline("sferik")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should eq "Google is throwing up a question mark for Sunday's weather in Boston. At least they're being honest. http://t.co/Jh7bAhS"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/statuses/media_timeline.json").
          to_return(:body => fixture("media_timeline.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.media_timeline
        a_get("/1/statuses/media_timeline.json").
          should have_been_made
      end
    end
  end

  describe "#network_timeline" do
    before do
      stub_get("/i/statuses/network_timeline.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.network_timeline
      a_get("/i/statuses/network_timeline.json").
        should have_been_made
    end
    it "returns the 20 most recent tweets of the authenticated user that have been retweeted by others" do
      statuses = @client.network_timeline
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

end
