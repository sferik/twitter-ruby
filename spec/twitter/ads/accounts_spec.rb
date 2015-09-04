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

  describe '#account' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/gq0vll').to_return(body: fixture('account.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      account = @client.account('gq0vll')
      expect(account.id).to eq('gq0vll')
    end
  end

  describe '#scoped_timeline' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/abc123/scoped_timeline').with(query: { user_ids: 783214 }).to_return(body: fixture('scoped_timeline.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      tweets = @client.scoped_timeline('abc123', 783214)
      expect(tweets.count).to eq(1)
      expect(tweets.first.id).to eq(288524949692489728)
    end
  end
end
