require 'helper'

describe Twitter::Ads::Cursor do
  describe '#each' do
    before do
      @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
      stub_get('https://ads-api.twitter.com/0/accounts/abc123/campaigns').to_return(body: fixture('campaigns_1.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_get('https://ads-api.twitter.com/0/accounts/abc123/campaigns').with(query: {cursor: '8x7x8widc'}).to_return(body: fixture('campaigns_2.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resources' do
      @client.campaigns('abc123').each {}
      expect(a_get('https://ads-api.twitter.com/0/accounts/abc123/campaigns')).to have_been_made
      expect(a_get('https://ads-api.twitter.com/0/accounts/abc123/campaigns').with(query: {cursor: '8x7x8widc'})).to have_been_made
    end
    it 'iterates' do
      count = 0
      @client.campaigns('abc123').each { count += 1 }
      expect(count).to eq(6)
    end
    context 'with start' do
      it 'iterates' do
        count = 0
        @client.campaigns('abc123').each(5) { count += 1 }
        expect(count).to eq(1)
      end
    end
  end
end
