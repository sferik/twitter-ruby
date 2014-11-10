require 'helper'

describe Twitter::Headers do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
    @headers = Twitter::Headers.new(@client, :get, Twitter::REST::Request::BASE_URL + '/path')
  end

  describe '#oauth_auth_header' do
    it 'creates the correct auth headers' do
      authorization = @headers.oauth_auth_header
      expect(authorization.options[:signature_method]).to eq('HMAC-SHA1')
      expect(authorization.options[:version]).to eq('1.0')
      expect(authorization.options[:consumer_key]).to eq('CK')
      expect(authorization.options[:consumer_secret]).to eq('CS')
      expect(authorization.options[:token]).to eq('AT')
      expect(authorization.options[:token_secret]).to eq('AS')
    end
    it 'submits the correct auth header when no media is present' do
      # We use static values for nounce and timestamp to get a stable signature
      secret = {consumer_key: 'CK', consumer_secret: 'CS', token: 'OT', token_secret: 'OS', nonce: 'b6ebe4c2a11af493f8a2290fe1296965', timestamp: '1370968658', ignore_extra_keys: true}
      headers = {authorization: /oauth_signature="FbthwmgGq02iQw%2FuXGEWaL6V6eM%3D"/, content_type: 'application/json; charset=utf-8'}
      allow(@client).to receive(:credentials).and_return(secret)
      stub_post('/1.1/statuses/update.json').with(body: {status: 'Just a test'}).to_return(body: fixture('status.json'), headers: headers)
      @client.update('Just a test')
      expect(a_post('/1.1/statuses/update.json').with(headers: {authorization: headers[:authorization]})).to have_been_made
    end
    it 'submits the correct auth header when media is present' do
      secret = {consumer_key: 'CK', consumer_secret: 'CS', token: 'OT', token_secret: 'OS', nonce: 'e08201ad0dab4897c99445056feefd95', timestamp: '1370967652', ignore_extra_keys: true}
      headers = {authorization: /oauth_signature="JVkElZ8O3WXkpZjtEHYRk67pYdQ%3D"/, content_type: 'application/json; charset=utf-8'}
      allow(@client).to receive(:credentials).and_return(secret)
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(body: fixture('upload.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_post('/1.1/statuses/update.json').to_return(body: fixture('status.json'), headers: {content_type: 'application/json; charset=utf-8'})
      @client.update_with_media('Just a test', fixture('pbjt.gif'))
      expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made
      expect(a_post('/1.1/statuses/update.json').with(headers: {authorization: headers[:authorization]})).to have_been_made
    end
  end

  describe '#bearer_auth_header' do
    it 'creates the correct auth headers with supplied bearer token' do
      client = Twitter::REST::Client.new(bearer_token: 'BT')
      headers = Twitter::Headers.new(client, :get, Twitter::REST::Request::BASE_URL + '/path')
      authorization = headers.send(:bearer_auth_header)
      expect(authorization).to eq('Bearer BT')
    end
  end

  describe '#bearer_token_credentials_auth_header' do
    it 'creates the correct auth header with supplied consumer_key and consumer_secret' do
      authorization = @headers.send(:bearer_token_credentials_auth_header)
      expect(authorization).to eq('Basic Q0s6Q1M=')
    end
  end
end
