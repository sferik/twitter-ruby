require 'helper'

describe Twitter::REST::API::SpamReporting do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#report_spam" do
    before do
      stub_post("/1.1/users/report_spam.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.report_spam("sferik")
      expect(a_post("/1.1/users/report_spam.json").with(:body => {:screen_name => "sferik"})).to have_been_made
    end
    it "returns an array of users" do
      users = @client.report_spam("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7505382)
    end
  end

end
