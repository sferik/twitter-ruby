require 'helper'

describe Faraday::Request do
  before(:each) do
    @oauth = Faraday::Request::TwitterOAuth.new(lambda{|env| env}, Hash.new)
    @request = {:method => "post", :url => "http://test.com/test.json", :request_headers => {}, :body => {:status => "Test"}}
  end

  describe "OAuth v1" do
    it "should encode the entire body when no uploaded media is present" do
      response = SimpleOAuth::Header.parse(@oauth.call(@request)[:request_headers]["Authorization"])
      signature = response.delete(:signature)
      header = SimpleOAuth::Header.new(:post, "http://test.com/test.json", {:status => "Test"}, response)
      signature.should == SimpleOAuth::Header.parse(header.to_s)[:signature]
    end

    it "should encode none of the body when uploaded media is present" do
      @request[:body] = {:file => Faraday::UploadIO.new("Rakefile", "Test"), :status => "Test"}
      response = SimpleOAuth::Header.parse(@oauth.call( @request )[:request_headers]["Authorization"])
      signature = response.delete(:signature)
      header = SimpleOAuth::Header.new(:post, "http://test.com/test.json", {}, response)
      signature.should == SimpleOAuth::Header.parse(header.to_s)[:signature]
    end
  end
end
