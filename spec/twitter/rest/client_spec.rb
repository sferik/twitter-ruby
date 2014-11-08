require 'helper'

describe Twitter::REST::Client do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '.new' do
    context 'when invalid credentials are provided' do
      it 'raises a ConfigurationError exception' do
        expect { Twitter::REST::Client.new(consumer_key: [12_345, 54_321]) }.to raise_exception(Twitter::Error::ConfigurationError)
      end
    end
    context 'when no credentials are provided' do
      it 'does not raise an exception' do
        expect { Twitter::REST::Client.new }.not_to raise_error
      end
    end
  end

  describe '.credentials?' do
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

  it 'does not cache the screen name across clients' do
    stub_get('/1.1/account/verify_credentials.json').to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    user1 = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS').current_user
    stub_get('/1.1/account/verify_credentials.json').to_return(body: fixture('pengwynn.json'), headers: {content_type: 'application/json; charset=utf-8'})
    user2 = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS').current_user
    expect(user1).not_to eq(user2)
  end

  describe '#user_token?' do
    it 'returns true if the user token/secret are present' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
      expect(client.user_token?).to be true
    end
    it 'returns false if the user token/secret are not completely present' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT')
      expect(client.user_token?).to be false
    end
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
    it 'returns true if all credentials are present' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
      expect(client.credentials?).to be true
    end
    it 'returns false if any credentials are missing' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT')
      expect(client.credentials?).to be false
    end
  end
end
