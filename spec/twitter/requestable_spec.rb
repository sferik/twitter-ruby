require 'helper'

describe Twitter::Requestable do

  subject do
    client = Twitter::Client.new
    client.class_eval{public *Twitter::Requestable.private_instance_methods}
    client
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      subject.connection.should respond_to(:run_request)
    end
    it "memoizes the connection" do
      c1, c2 = subject.connection, subject.connection
      c1.object_id.should eq c2.object_id
    end
  end

  describe "#request" do
    before do
      @client = Twitter::Client.new({:consumer_key => "CK", :consumer_secret => "CS", :oauth_token => "OT", :oauth_token_secret => "OS"})
    end
    it "encodes the entire body when no uploaded media is present" do
      stub_post("/1/statuses/update.json").
        with(:body => {:status => "Update"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @client.update("Update")
      a_post("/1/statuses/update.json").
        with(:body => {:status => "Update"}).
        should have_been_made
    end
    it "encodes none of the body when uploaded media is present" do
      stub_post("/1/statuses/update_with_media.json", Twitter.media_endpoint).
        to_return(:body => fixture("status_with_media.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @client.update_with_media("Update", fixture("pbjt.gif"))
      a_post("/1/statuses/update_with_media.json", Twitter.media_endpoint).
        should have_been_made
    end
    it "catches Faraday errors" do
      subject.stub!(:connection).and_raise(Faraday::Error::ClientError.new("Oups"))
      lambda do
        subject.request(:get, "/path", {}, {})
      end.should raise_error(Twitter::Error::ClientError, "Oups")
    end
  end

end
