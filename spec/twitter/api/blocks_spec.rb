require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#blocking" do
    before do
      stub_get("/1.1/blocks/list.json").
        with(:query => {:cursor => "-1"}).
        to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.blocking
      a_get("/1.1/blocks/list.json").
        with(:query => {:cursor => "-1"}).
        should have_been_made
    end
    it "returns an array of user objects that the authenticating user is blocking" do
      blocking = @client.blocking
      blocking.should be_a Twitter::Cursor
      blocking.users.should be_an Array
      blocking.users.first.should be_a Twitter::User
      blocking.users.first.id.should eq 7505382
    end
  end

  describe "#blocked_ids" do
    before do
      stub_get("/1.1/blocks/ids.json").
        with(:query => {:cursor => "-1"}).
        to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.blocked_ids
      a_get("/1.1/blocks/ids.json").
        with(:query => {:cursor => "-1"}).
        should have_been_made
    end
    it "returns an array of numeric user IDs the authenticating user is blocking" do
      blocked_ids = @client.blocked_ids
      blocked_ids.should be_a Twitter::Cursor
      blocked_ids.ids.should be_an Array
      blocked_ids.ids.first.should eq 14100886
    end
  end

  describe "#block?" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "1305102810874389703"}).
          to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").
          with(:query => {:screen_name => "pengwynn"}).
          to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/users/show.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.block?("sferik")
        a_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "1305102810874389703"}).
          should have_been_made
        a_get("/1.1/users/show.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns true if block exists" do
        block = @client.block?("pengwynn")
        block.should be_true
      end
      it "returns false if block does not exist" do
        block = @client.block?("sferik")
        block.should be_false
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "1305102810874389703"}).
          to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resources" do
        @client.block?(7505382)
        a_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "1305102810874389703"}).
          should have_been_made
      end
    end
    context "with a user object passed" do
      before do
        stub_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "1305102810874389703"}).
          to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resources" do
        user = Twitter::User.new(:id => '7505382')
        @client.block?(user)
        a_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_get("/1.1/blocks/ids.json").
          with(:query => {:cursor => "1305102810874389703"}).
          should have_been_made
      end
    end
  end

  describe "#block" do
    before do
      stub_post("/1.1/blocks/create.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.block("sferik")
      a_post("/1.1/blocks/create.json").
        should have_been_made
    end
    it "returns an array of blocked users" do
      users = @client.block("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.id.should eq 7505382
    end
  end

  describe "#unblock" do
    before do
      stub_post("/1.1/blocks/destroy.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.unblock("sferik")
      a_post("/1.1/blocks/destroy.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns an array of un-blocked users" do
      users = @client.unblock("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.id.should eq 7505382
    end
  end

end
