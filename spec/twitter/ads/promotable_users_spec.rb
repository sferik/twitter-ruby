require 'helper'

describe Twitter::Ads::PromotableUsers do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#promotable_users' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/promotable_users').to_return(body: fixture('promotable_users.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.promotable_users('hkk5')
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/promotable_users')).to have_been_made
    end
    it 'gets the right resources' do
      promotable_users = @client.promotable_users('hkk5')
      expect(promotable_users.map(&:id)).to match(['45nb5'])
    end
  end
end
