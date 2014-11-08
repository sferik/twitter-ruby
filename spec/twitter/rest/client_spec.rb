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

  describe '#get' do
    before do
      stub_get('/path')
    end
    it 'performs an HTTP GET' do
      capture_warning do
        @client.get('/path')
      end
      expect(a_get('/path')).to have_been_made
    end
    it 'outputs a warning' do
      warning = capture_warning do
        @client.get('/path')
      end
      expect(warning).to match(/\[DEPRECATION\] Twitter::REST::Client#get is deprecated\. Use Twitter::REST::Request#perform instead\.$/)
    end
  end

  describe '#post' do
    before do
      stub_post('/path')
    end
    it 'performs an HTTP GET' do
      capture_warning do
        @client.post('/path')
      end
      expect(a_post('/path')).to have_been_made
    end
    it 'outputs a warning' do
      warning = capture_warning do
        @client.post('/path')
      end
      expect(warning).to match(/\[DEPRECATION\] Twitter::REST::Client#post is deprecated\. Use Twitter::REST::Request#perform instead\.$/)
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

  describe '#connection_options=' do
    it 'sets connection options' do
      capture_warning do
        @client.connection_options = 'connection options'
      end
      expect(@client.connection_options).to eq('connection options')
    end
    it 'outputs a warning' do
      warning = capture_warning do
        @client.connection_options = nil
      end
      expect(warning).to match(/\[DEPRECATION\] Twitter::REST::Client#connection_options= is deprecated and will be removed\.$/)
    end
  end

  describe '#connection_options' do
    it 'returns the connection options hash with proxy and user_agent' do
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = 'CK'
        config.consumer_secret     = 'CS'
        config.access_token        = 'AT'
        config.access_token_secret = 'ATS'
        config.proxy               = 'http://localhost:99'
        config.user_agent          = 'My Twitter Ruby Gem'
      end
      expect(client.connection_options[:proxy]).to eql('http://localhost:99')
      expect(client.connection_options[:headers][:user_agent]).to eql('My Twitter Ruby Gem')
    end
  end

  describe '#middleware=' do
    it 'sets middleware' do
      capture_warning do
        @client.middleware = 'middleware'
      end
      expect(@client.middleware).to eq 'middleware'
    end
    it 'outputs a warning' do
      warning = capture_warning do
        @client.middleware = nil
      end
      expect(warning).to match(/\[DEPRECATION\] Twitter::REST::Client#middleware= is deprecated and will be removed\.$/)
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

  describe '#connection' do
    it 'looks like Faraday connection' do
      expect(@client.send(:connection)).to respond_to(:run_request)
    end
    it 'memoizes the connection' do
      c1 = @client.send(:connection)
      c2 = @client.send(:connection)
      expect(c1.object_id).to eq(c2.object_id)
    end
  end
end
