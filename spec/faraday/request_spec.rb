require 'helper'
require 'faraday'
require 'faraday/request/oauth'
require 'simple_oauth'

describe Faraday::Request do
  before(:each) do
    @oauth = Faraday::Request::OAuth.new lambda { |env| return env }, Hash.new
    @req = { :method => "post", :url => "http://test.com/test.JSON", :request_headers => {}, :body => { :status => "Yar" } }
  end
  
  describe "OAuth v1" do
    it "should encode the entire body when no uploaded media is present" do
      res = SimpleOAuth::Header.parse(@oauth.call( @req )[:request_headers]["Authorization"])
      sig = res[:signature]
      res.delete(:signature)
      
      newhead = SimpleOAuth::Header.new(:post, "http://test.com/test.JSON", { :status => "Yar" }, res)
      sig.should == SimpleOAuth::Header.parse(newhead.to_s)[:signature]
    end
    
    it "should encode none of the body when uploaded media is present" do
      @req[:body] = { :file => Faraday::UploadIO.new("Rakefile", "Test"), :status => "Yar" }
      res = SimpleOAuth::Header.parse(@oauth.call( @req )[:request_headers]["Authorization"])
      sig = res[:signature]
      res.delete(:signature)
      
      newhead = SimpleOAuth::Header.new(:post, "http://test.com/test.JSON", { }, res)
      sig.should == SimpleOAuth::Header.parse(newhead.to_s)[:signature]
    end
  end
end