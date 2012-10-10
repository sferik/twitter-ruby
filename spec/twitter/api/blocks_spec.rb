require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#blocking" do
    before do
      stub_get("/1.1/blocks/list.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.blocking
      expect(a_get("/1.1/blocks/list.json").with(:query => {:cursor => "-1"})).to have_been_made
    end
    it "returns an array of user objects that the authenticating user is blocking" do
      blocking = @client.blocking
      expect(blocking).to be_a Twitter::Cursor
      expect(blocking.users).to be_an Array
      expect(blocking.users.first).to be_a Twitter::User
      expect(blocking.users.first.id).to eq 7505382
    end
  end

  describe "#blocked_ids" do
    before do
      stub_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.blocked_ids
      expect(a_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
    end
    it "returns an array of numeric user IDs the authenticating user is blocking" do
      blocked_ids = @client.blocked_ids
      expect(blocked_ids).to be_a Twitter::Cursor
      expect(blocked_ids.ids).to be_an Array
      expect(blocked_ids.ids.first).to eq 14100886
    end
  end

  describe "#block?" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(:query => {:cursor => "1305102810874389703"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").with(:query => {:screen_name => "pengwynn"}).to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.block?("sferik")
        expect(a_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/ids.json").with(:query => {:cursor => "1305102810874389703"})).to have_been_made
        expect(a_get("/1.1/users/show.json").with(:query => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns true if block exists" do
        block = @client.block?("pengwynn")
        expect(block).to be_true
      end
      it "returns false if block does not exist" do
        block = @client.block?("sferik")
        expect(block).to be_false
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(:query => {:cursor => "1305102810874389703"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resources" do
        @client.block?(7505382)
        expect(a_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/ids.json").with(:query => {:cursor => "1305102810874389703"})).to have_been_made
      end
    end
    context "with a user object passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").with(:query => {:cursor => "1305102810874389703"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resources" do
        user = Twitter::User.new(:id => '7505382')
        @client.block?(user)
        expect(a_get("/1.1/blocks/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
        expect(a_get("/1.1/blocks/ids.json").with(:query => {:cursor => "1305102810874389703"})).to have_been_made
      end
    end
  end

  describe "#block" do
    before do
      stub_post("/1.1/blocks/create.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.block("sferik")
      expect(a_post("/1.1/blocks/create.json")).to have_been_made
    end
    it "returns an array of blocked users" do
      users = @client.block("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq 7505382
    end
  end

  describe "#unblock" do
    before do
      stub_post("/1.1/blocks/destroy.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.unblock("sferik")
      expect(a_post("/1.1/blocks/destroy.json").with(:body => {:screen_name => "sferik"})).to have_been_made
    end
    it "returns an array of un-blocked users" do
      users = @client.unblock("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq 7505382
    end
  end

end
