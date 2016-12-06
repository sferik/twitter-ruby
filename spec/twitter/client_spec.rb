require 'helper'

describe Twitter::Client do
  describe '#user_agent' do
    it 'defaults TwitterRubyGem/version' do
      expect(subject.user_agent).to eq("TwitterRubyGem/#{Twitter::Version}")
    end
  end

  describe '#user_agent=' do
    it 'overwrites the User-Agent string' do
      subject.user_agent = 'MyTwitterClient/1.0.0'
      expect(subject.user_agent).to eq('MyTwitterClient/1.0.0')
    end
  end

  describe '#user_token?' do
    it 'returns true if the user token/secret are present' do
      client = Twitter::REST::Client.new(access_token: 'AT', access_token_secret: 'AS')
      expect(client.user_token?).to be true
    end
    it 'returns false if the user token/secret are not completely present' do
      client = Twitter::REST::Client.new(access_token: 'AT')
      expect(client.user_token?).to be false
    end
    it 'returns false if any user token/secret is blank' do
      client = Twitter::REST::Client.new(access_token: '', access_token_secret: 'AS')
      expect(client.user_token?).to be false

      client = Twitter::REST::Client.new(access_token: 'AT', access_token_secret: '')
      expect(client.user_token?).to be false
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
    it 'returns false if any credential is blank' do
      client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: '')
      expect(client.credentials?).to be false
    end
  end
end
