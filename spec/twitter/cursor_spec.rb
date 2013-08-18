require 'helper'

describe Twitter::Cursor do

  describe "#each" do
    before do
      @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
      stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resources" do
      @client.follower_ids("sferik").each{}
      expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"})).to have_been_made
    end
    it "iterates" do
      count = 0
      @client.follower_ids("sferik").each{count += 1}
      expect(count).to eq(6)
    end
    context "with start" do
      it "iterates" do
        count = 0
        @client.follower_ids("sferik").each(5){count += 1}
        expect(count).to eq(1)
      end
    end
  end

  describe "#first?" do
    context "when previous cursor equals zero" do
      before do
        @cursor = Twitter::Cursor.new({:previous_cursor => 0}, :ids, nil, Twitter::REST::Client.new, :get, "/1.1/followers/ids.json", {})
      end
      it "returns true" do
        expect(@cursor.first?).to be_true
      end
    end
    context "when previous cursor does not equal zero" do
      before do
        @cursor = Twitter::Cursor.new({:previous_cursor => 1}, :ids, nil, Twitter::REST::Client.new, :get, "/1.1/followers/ids.json", {})
      end
      it "returns true" do
        expect(@cursor.first?).to be_false
      end
    end
  end

  describe "#last?" do
    context "when next cursor equals zero" do
      before do
        @cursor = Twitter::Cursor.new({:next_cursor => 0}, :ids, nil, Twitter::REST::Client.new, :get, "/1.1/followers/ids.json", {})
      end
      it "returns true" do
        expect(@cursor.last?).to be_true
      end
    end
    context "when next cursor does not equal zero" do
      before do
        @cursor = Twitter::Cursor.new({:next_cursor => 1}, :ids, nil, Twitter::REST::Client.new, :get, "/1.1/followers/ids.json", {})
      end
      it "returns false" do
        expect(@cursor.last?).to be_false
      end
    end
  end

end
