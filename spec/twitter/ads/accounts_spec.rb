require 'helper'

describe Twitter::Ads::Accounts do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#accounts' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts').to_return(body: fixture('accounts.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.accounts
      expect(a_get('https://ads-api.twitter.com/0/accounts')).to have_been_made
    end

    it 'gets the right resources' do
      accounts = @client.accounts
      expect(accounts).to be_an Array
      expect(accounts.first).to be_a Twitter::Account
      expect(accounts.first.id).to eq('gq0vll')
    end
  end
end
