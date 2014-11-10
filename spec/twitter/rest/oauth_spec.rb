require 'helper'

describe Twitter::REST::OAuth do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS')
  end

  describe '#token' do
    before do
      stub_post('/oauth2/token').with(body: {grant_type: 'client_credentials'}).to_return(body: fixture('bearer_token.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.token
      expect(a_post('/oauth2/token').with(body: {grant_type: 'client_credentials'}, headers: {authorization: 'Basic Q0s6Q1M=', content_type: 'application/x-www-form-urlencoded', accept: '*/*'})).to have_been_made
    end
    it 'returns the bearer token' do
      bearer_token = @client.token
      expect(bearer_token).to be_a String
      expect(bearer_token).to eq('AAAA%2FAAA%3DAAAAAAAA')
    end
  end

  describe '#invalidate_token' do
    before do
      stub_post('/oauth2/invalidate_token').with(body: {access_token: 'AAAA%2FAAA%3DAAAAAAAA'}).to_return(body: '{"access_token":"AAAA%2FAAA%3DAAAAAAAA"}', headers: {content_type: 'application/json; charset=utf-8'})
      @client.bearer_token = 'AAAA%2FAAA%3DAAAAAAAA'
    end
    it 'requests the correct resource' do
      @client.invalidate_token('AAAA%2FAAA%3DAAAAAAAA')
      expect(a_post('/oauth2/invalidate_token').with(body: {access_token: 'AAAA%2FAAA%3DAAAAAAAA'})).to have_been_made
    end
    it 'returns the invalidated token' do
      token = @client.invalidate_token('AAAA%2FAAA%3DAAAAAAAA')
      expect(token).to be_a String
      expect(token).to eq('AAAA%2FAAA%3DAAAAAAAA')
    end
    context 'with a token' do
      it 'requests the correct resource' do
        token = 'AAAA%2FAAA%3DAAAAAAAA'
        @client.invalidate_token(token)
        expect(a_post('/oauth2/invalidate_token').with(body: {access_token: 'AAAA%2FAAA%3DAAAAAAAA'})).to have_been_made
      end
    end
  end

  describe '#reverse_token' do
    before do
      # WebMock treats Basic Auth differently so we have to check against the full URL with credentials.
      @oauth_request_token_url = 'https://api.twitter.com/oauth/request_token?x_auth_mode=reverse_auth'
      stub_request(:post, @oauth_request_token_url).to_return(body: fixture('request_token.txt'), headers: {content_type: 'text/html; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.reverse_token
      expect(a_request(:post, @oauth_request_token_url).with(query: {x_auth_mode: 'reverse_auth'})).to have_been_made
    end
    it 'requests the correct resource' do
      expect(@client.reverse_token).to eql fixture('request_token.txt').read
    end
  end
end
