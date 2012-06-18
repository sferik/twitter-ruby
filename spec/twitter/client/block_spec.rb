require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#blocking" do
    before do
      stub_get("/1/blocks/blocking.json").
        to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.blocking
      a_get("/1/blocks/blocking.json").
        should have_been_made
    end
    it "returns an array of user objects that the authenticating user is blocking" do
      users = @client.blocking
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#blocked_ids" do
    before do
      stub_get("/1/blocks/blocking/ids.json").
        to_return(:body => fixture("ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.blocked_ids
      a_get("/1/blocks/blocking/ids.json").
        should have_been_made
    end
    it "returns an array of numeric user IDs the authenticating user is blocking" do
      ids = @client.blocked_ids
      ids.should be_an Array
      ids.first.should eq 47
    end
  end

  describe "#block?" do
    before do
      stub_get("/1/blocks/exists.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1/blocks/exists.json").
        with(:query => {:screen_name => "pengwynn"}).
        to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.block?("sferik")
      a_get("/1/blocks/exists.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns true if block exists" do
      block = @client.block?("sferik")
      block.should be_true
    end
    it "returns false if block does not exist" do
      block = @client.block?("pengwynn")
      block.should be_false
    end
  end

  describe "#block" do
    before do
      stub_post("/1/blocks/create.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.block("sferik")
      a_post("/1/blocks/create.json").
        should have_been_made
    end
    it "returns an array of blocked users" do
      users = @client.block("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#unblock" do
    before do
      stub_delete("/1/blocks/destroy.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.unblock("sferik")
      a_delete("/1/blocks/destroy.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns an array of un-blocked users" do
      users = @client.unblock("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

end
