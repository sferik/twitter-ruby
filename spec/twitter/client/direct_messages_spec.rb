require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#direct_messages_received" do
    before do
      stub_get("/1/direct_messages.json").
        to_return(:body => fixture("direct_messages.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.direct_messages_received
      a_get("/1/direct_messages.json").
        should have_been_made
    end
    it "returns the 20 most recent direct messages sent to the authenticating user" do
      direct_messages = @client.direct_messages_received
      direct_messages.should be_an Array
      direct_messages.first.should be_a Twitter::DirectMessage
      direct_messages.first.sender.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#direct_messages_sent" do
    before do
      stub_get("/1/direct_messages/sent.json").
        to_return(:body => fixture("direct_messages.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.direct_messages_sent
      a_get("/1/direct_messages/sent.json").
        should have_been_made
    end
    it "returns the 20 most recent direct messages sent by the authenticating user" do
      direct_messages = @client.direct_messages_sent
      direct_messages.should be_an Array
      direct_messages.first.should be_a Twitter::DirectMessage
      direct_messages.first.sender.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#direct_message_destroy" do
    before do
      stub_delete("/1/direct_messages/destroy/1825785544.json").
        to_return(:body => fixture("direct_message.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.direct_message_destroy(1825785544)
      a_delete("/1/direct_messages/destroy/1825785544.json").
        should have_been_made
    end
    it "returns an array of deleted messages" do
      direct_messages = @client.direct_message_destroy(1825785544)
      direct_messages.should be_an Array
      direct_messages.first.should be_a Twitter::DirectMessage
      direct_messages.first.sender.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#direct_message_create" do
    before do
      stub_post("/1/direct_messages/new.json").
        with(:body => {:screen_name => "pengwynn", :text => "Creating a fixture for the Twitter gem"}).
        to_return(:body => fixture("direct_message.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.direct_message_create("pengwynn", "Creating a fixture for the Twitter gem")
      a_post("/1/direct_messages/new.json").
        with(:body => {:screen_name => "pengwynn", :text => "Creating a fixture for the Twitter gem"}).
        should have_been_made
    end
    it "returns the sent message" do
      direct_message = @client.direct_message_create("pengwynn", "Creating a fixture for the Twitter gem")
      direct_message.should be_a Twitter::DirectMessage
      direct_message.text.should eq "Creating a fixture for the Twitter gem"
    end
  end

  describe "#direct_message" do
    before do
      stub_get("/1/direct_messages/show/1825786345.json").
        to_return(:body => fixture("direct_message.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.direct_message(1825786345)
      a_get("/1/direct_messages/show/1825786345.json").
        should have_been_made
    end
    it "returns the specified direct message" do
      direct_message = @client.direct_message(1825786345)
      direct_message.should be_a Twitter::DirectMessage
      direct_message.sender.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#direct_messages" do
    context "with ids passed" do
      before do
        stub_get("/1/direct_messages/show/1825786345.json").
          to_return(:body => fixture("direct_message.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.direct_messages(1825786345)
        a_get("/1/direct_messages/show/1825786345.json").
          should have_been_made
      end
      it "returns an array of direct messages" do
        direct_messages = @client.direct_messages(1825786345)
        direct_messages.should be_an Array
        direct_messages.first.should be_a Twitter::DirectMessage
        direct_messages.first.sender.name.should eq "Erik Michaels-Ober"
      end
    end
    context "without ids passed" do
      before do
        stub_get("/1/direct_messages.json").
          to_return(:body => fixture("direct_messages.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.direct_messages
        a_get("/1/direct_messages.json").
          should have_been_made
      end
      it "returns the 20 most recent direct messages sent to the authenticating user" do
        direct_messages = @client.direct_messages
        direct_messages.should be_an Array
        direct_messages.first.should be_a Twitter::DirectMessage
        direct_messages.first.sender.name.should eq "Erik Michaels-Ober"
      end
    end
  end

end
