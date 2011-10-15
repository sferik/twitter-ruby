require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe ".report_spam" do
    before do
      stub_post("/1/report_spam.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should get the correct resource" do
      @client.report_spam("sferik")
      a_post("/1/report_spam.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "should return the specified user" do
      user = @client.report_spam("sferik")
      user.should be_a Twitter::User
      user.name.should == "Erik Michaels-Ober"
    end
  end

end
