require 'helper'

describe Twitter::Ads::Statistics do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#account_stats' do
  end

  describe '#campaign_stats' do
    context 'non-segmented' do
      before do
        stub_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/campaigns/e25e')
          .with(query: {granularity: 'DAY', start_time: '2013-04-13T07:00:00Z'}).to_return(body: fixture('campaign_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end

      it 'requests resources' do
        @client.campaign_stats('5gvk9h', 'e25e', start_time: '2013-04-13T07:00:00Z', granularity: 'DAY')
        expect(a_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/campaigns/e25e').with(query: {granularity: 'DAY', start_time: '2013-04-13T07:00:00Z'})).to have_been_made
      end

      it 'gets the right resource' do
        stats = @client.campaign_stats('5gvk9h', 'e25e', start_time: '2013-04-13T07:00:00Z', granularity: 'DAY')
        expect(stats.id).to eq('e25e')
        expect(stats.promoted_tweet_timeline_impressions).to eq([851, 875, 1187])
      end
    end
    context 'segmented' do
      before do
        stub_get('https://ads-api.twitter.com/0/stats/accounts/abc1/campaigns/1ldet')
          .with(query: {granularity: 'DAY', segmentation_type: 'GENDER', start_time: '2013-07-07T07:00:00Z'}).to_return(body: fixture('campaign_stats_segmented.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resources' do
        @client.campaign_stats('abc1', '1ldet', start_time: '2013-07-07T07:00:00Z', granularity: 'DAY', segmentation_type: 'GENDER')
        expect(a_get('https://ads-api.twitter.com/0/stats/accounts/abc1/campaigns/1ldet').with(query: {granularity: 'DAY', start_time: '2013-07-07T07:00:00Z', segmentation_type: 'GENDER'})).to have_been_made
      end
    end
  end

  describe '#line_item_stats' do
  end

  describe '#promoted_tweet_stats' do
  end

  describe '#promoted_account_stats' do
  end

  describe '#funding_instrument_stats' do
  end

  describe '#campaigns_stats' do
  end

  describe '#line_items_stats' do
  end

  describe '#promoted_tweets_stats' do
  end

  describe '#promoted_accounts_stats' do
  end

  describe '#funding_instruments_stats' do
  end
end
