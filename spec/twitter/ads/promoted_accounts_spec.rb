require 'helper'

describe Twitter::Ads::PromotedAccounts do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#promoted_accounts' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/promoted_accounts').to_return(body: fixture('promoted_accounts.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.promoted_accounts('hkk5')
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/promoted_accounts')).to have_been_made
    end
    it 'gets the right resources' do
      promoted_accounts = @client.promoted_accounts('hkk5')
      expect(promoted_accounts.map(&:id)).to match(['2iu7'])
    end
  end

  describe '#promote_account' do
    let(:expected) do
      {
        line_item_id: '43853bh6lk5d',
        user_id: '6253282',
      }
    end
    before do
      stub_post('https://ads-api.twitter.com/0/accounts/43853bhii879/promoted_accounts').with(body: expected)
        .to_return(body: fixture('promoted_account_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'creates a campgin' do
      promoted_account = @client.promote_account('43853bhii879', '43853bh6lk5d', '6253282')
      expect(a_post('https://ads-api.twitter.com/0/accounts/43853bhii879/promoted_accounts')).to have_been_made
      expect(promoted_account).to be_a Twitter::PromotedAccount
      expect(promoted_account.id).to eq('c1s3')
    end
  end
end
