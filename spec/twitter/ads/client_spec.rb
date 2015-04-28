require 'helper'

describe Twitter::Ads::Client do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#bearer_token?' do
    it 'returns true if the app token is present' do
      client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', bearer_token: 'BT')
      expect(client.bearer_token?).to be true
    end
    it 'returns false if the bearer_token is not present' do
      client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS')
      expect(client.bearer_token?).to be false
    end
  end

  describe '#credentials?' do
    it 'returns true if only bearer_token is supplied' do
      client = Twitter::Ads::Client.new(bearer_token: 'BT')
      expect(client.credentials?).to be true
    end
    it 'returns true if all OAuth credentials are present' do
      client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
      expect(client.credentials?).to be true
    end
    it 'returns false if any credentials are missing' do
      client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT')
      expect(client.credentials?).to be false
    end
  end
end
