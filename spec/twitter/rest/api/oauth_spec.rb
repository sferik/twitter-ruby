require 'helper'

describe Twitter::REST::API::OAuth do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS")
  end

  describe "#token" do
    before do
      # WebMock treats Basic Auth differently so we have to chack against the full URL with credentials.
      @oauth2_token_url = "https://CK:CS@api.twitter.com/oauth2/token"
      stub_request(:post, @oauth2_token_url).with(:body => "grant_type=client_credentials").to_return(:body => fixture("bearer_token.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.token
      expect(a_request(:post, @oauth2_token_url).with(:body => {:grant_type => "client_credentials"})).to have_been_made
    end
    it "requests with the correct headers" do
      @client.token
      expect(a_request(:post, @oauth2_token_url).with(:headers => {
          :content_type => "application/x-www-form-urlencoded; charset=UTF-8",
          :accept => "*/*"
        })).to have_been_made
    end
    it "returns the bearer token" do
      bearer_token = @client.token
      expect(bearer_token.access_token).to eq("AAAA%2FAAA%3DAAAAAAAA")
      expect(bearer_token.token_type).to eq("bearer")
    end
  end

  describe "#invalidate_token" do
    before do
      stub_post("/oauth2/invalidate_token").with(:body => {:access_token => "AAAA%2FAAA%3DAAAAAAAA"}).to_return(:body => '{"access_token" : "AAAA%2FAAA%3DAAAAAAAA"}', :headers => {:content_type => "application/json; charset=utf-8"})
      @client.bearer_token = "AAAA%2FAAA%3DAAAAAAAA"
    end
    it "requests the correct resource" do
      @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")
      expect(a_post("/oauth2/invalidate_token").with(:body => {:access_token => "AAAA%2FAAA%3DAAAAAAAA"})).to have_been_made
    end
    it "returns the invalidated token" do
      token = @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")
      expect(token.access_token).to eq("AAAA%2FAAA%3DAAAAAAAA")
      expect(token.token_type).to be_nil
    end
    context "with a token" do
      it "requests the correct resource" do
        token = Twitter::Token.new(:access_token => "AAAA%2FAAA%3DAAAAAAAA")
        @client.invalidate_token(token)
        expect(a_post("/oauth2/invalidate_token").with(:body => {:access_token => "AAAA%2FAAA%3DAAAAAAAA"})).to have_been_made
      end
    end
  end

end
