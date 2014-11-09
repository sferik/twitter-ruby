require 'helper'

describe Twitter::REST::Client do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#bearer_token?' do
    it 'returns true if the app token is present' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', bearer_token: 'BT')
      expect(client.bearer_token?).to be true
    end
    it 'returns false if the bearer_token is not present' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS')
      expect(client.bearer_token?).to be false
    end
  end

  describe '#credentials?' do
    it 'returns true if only bearer_token is supplied' do
      client = Twitter::REST::Client.new(bearer_token: 'BT')
      expect(client.credentials?).to be true
    end
    it 'returns true if all OAuth credentials are present' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
      expect(client.credentials?).to be true
    end
    it 'returns false if any credentials are missing' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT')
      expect(client.credentials?).to be false
    end
  end

  describe '#user_id' do
    it 'caches the user ID' do
      stub_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
      2.times { client.send(:user_id) }
      expect(a_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'})).to have_been_made.times(1)
    end

    it 'does not cache the user ID across clients' do
      stub_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS').send(:user_id)
      Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS').send(:user_id)
      expect(a_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'})).to have_been_made.times(2)
    end
  end
end
