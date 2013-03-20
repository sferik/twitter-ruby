require 'helper'

describe Twitter::API::OAuth do

  before do
    @client = Twitter::Client.new
  end

  describe "#invalidate_token" do
    before do
      stub_post("/oauth2/invalidate_token").with(:body => {:access_token => "AAAA%2FAAA%3DAAAAAAAA"}).to_return(:body => '{"access_token" : "AAAA%2FAAA%3DAAAAAAAA"}', :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")
      expect(a_post("/oauth2/invalidate_token").with(:body => {:access_token => "AAAA%2FAAA%3DAAAAAAAA"})).to have_been_made
    end
    it "returns the invalidated token" do
      token = @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")
      expect(token.access_token).to eq "AAAA%2FAAA%3DAAAAAAAA"
      expect(token.token_type).to eq nil
    end
  end
end