require 'helper'

describe Twitter::Ads::Statistics do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#account_stats' do
    let(:start_time) { '2012-11-20T07:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/43853bhii879')
        .with(query: {granularity: 'TOTAL', start_time: start_time}).to_return(body: fixture('account_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.account_stats('43853bhii879', start_time: start_time, granularity: 'TOTAL')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/43853bhii879').with(query: {granularity: 'TOTAL', start_time: start_time})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.account_stats('43853bhii879', start_time: start_time, granularity: 'TOTAL')
      expect(stats.id).to eq('43853bhii879')
      expect(stats.promoted_tweet_timeline_retweets).to eq([28])
    end
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
    let(:start_time) { '2012-11-20T07:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/line_items/5woz')
        .with(query: {granularity: 'DAY', start_time: start_time}).to_return(body: fixture('line_item_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.line_item_stats('hkk5', '5woz', start_time: start_time, granularity: 'DAY')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/line_items/5woz').with(query: {granularity: 'DAY', start_time: start_time})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.line_item_stats('hkk5', '5woz', start_time: start_time, granularity: 'DAY')
      expect(stats.id).to eq('5woz')
      expect(stats.promoted_tweet_timeline_clicks.reduce(:+)).to eq(1128)
    end
  end

  describe '#promoted_tweet_stats' do
    let(:start_time) { '2012-11-20T07:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/4cury/promoted_tweets/2m4ky')
        .with(query: {granularity: 'TOTAL', start_time: start_time}).to_return(body: fixture('promoted_tweet_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.promoted_tweet_stats('4cury', '2m4ky', start_time: start_time, granularity: 'TOTAL')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/4cury/promoted_tweets/2m4ky').with(query: {granularity: 'TOTAL', start_time: start_time})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.promoted_tweet_stats('4cury', '2m4ky', start_time: start_time, granularity: 'TOTAL')
      expect(stats.id).to eq('2m4ky')
      expect(stats.promoted_tweet_search_clicks).to eq([0])
    end
  end

  describe '#promoted_account_stats' do
    let(:start_time) { '2013-05-01T00:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/promoted_accounts/d9qr')
        .with(query: {granularity: 'TOTAL', start_time: start_time}).to_return(body: fixture('promoted_account_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.promoted_account_stats('hkk5', 'd9qr', start_time: start_time, granularity: 'TOTAL')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/promoted_accounts/d9qr').with(query: {granularity: 'TOTAL', start_time: start_time})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.promoted_account_stats('hkk5', 'd9qr', start_time: start_time, granularity: 'TOTAL')
      expect(stats.id).to eq('d9qr')
      expect(stats.promoted_account_impressions).to eq([30689])
    end
  end

  describe '#funding_instrument_stats' do
    let(:start_time) { '2013-04-13T07:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/funding_instruments/e25e')
        .with(query: {granularity: 'DAY', start_time: start_time}).to_return(body: fixture('funding_instrument_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.funding_instrument_stats('5gvk9h', 'e25e', start_time: start_time, granularity: 'DAY')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/funding_instruments/e25e').with(query: {granularity: 'DAY', start_time: start_time})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.funding_instrument_stats('5gvk9h', 'e25e', start_time: start_time, granularity: 'DAY')
      expect(stats.id).to eq('e25e')
      expect(stats.promoted_tweet_timeline_engagements).to eq([65, 75, 81])
    end
  end

  describe '#campaigns_stats' do
    let(:start_time) { '2013-04-13T07:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/campaigns')
        .with(query: {granularity: 'DAY', start_time: start_time, campaign_ids: 'e25e'}).to_return(body: fixture('campaigns_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.campaigns_stats('5gvk9h', ['e25e'], start_time: start_time, granularity: 'DAY')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/campaigns').with(query: {granularity: 'DAY', start_time: start_time, campaign_ids: 'e25e'})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.campaigns_stats('5gvk9h', ['e25e'], start_time: start_time, granularity: 'DAY')
      expect(stats.first.id).to eq('e25e')
      expect(stats.first.promoted_tweet_timeline_engagements).to eq([65, 75, 81])
    end
  end

  describe '#line_items_stats' do
    let(:start_time) { '2013-04-13T07:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/line_items')
        .with(query: {granularity: 'DAY', start_time: start_time, line_item_ids: '5woz'}).to_return(body: fixture('line_items_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.line_items_stats('hkk5', ['5woz'], start_time: start_time, granularity: 'DAY')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/line_items').with(query: {granularity: 'DAY', start_time: start_time, line_item_ids: '5woz'})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.line_items_stats('hkk5', ['5woz'], start_time: start_time, granularity: 'DAY')
      expect(stats.first.id).to eq('5woz')
      expect(stats.first.promoted_tweet_timeline_clicks.reduce(:+)).to eq(1128)
    end
  end

  describe '#promoted_tweets_stats' do
    let(:start_time) { '2013-04-01T00:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/promoted_tweets')
        .with(query: {granularity: 'TOTAL', start_time: start_time, promoted_tweet_ids: 'rd9q'}).to_return(body: fixture('promoted_tweets_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.promoted_tweets_stats('hkk5', ['rd9q'], start_time: start_time, granularity: 'TOTAL')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/promoted_tweets').with(query: {granularity: 'TOTAL', start_time: start_time, promoted_tweet_ids: 'rd9q'})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.promoted_tweets_stats('hkk5', ['rd9q'], start_time: start_time, granularity: 'TOTAL')
      expect(stats.first.id).to eq('rd9q')
      expect(stats.first.promoted_account_follows).to eq([59])
    end
  end

  describe '#promoted_accounts_stats' do
    let(:start_time) { '2013-04-01T00:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/promoted_accounts')
        .with(query: {granularity: 'TOTAL', start_time: start_time, promoted_account_ids: 'd9qr'}).to_return(body: fixture('promoted_accounts_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.promoted_accounts_stats('hkk5', ['d9qr'], start_time: start_time, granularity: 'TOTAL')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/hkk5/promoted_accounts').with(query: {granularity: 'TOTAL', start_time: start_time, promoted_account_ids: 'd9qr'})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.promoted_accounts_stats('hkk5', ['d9qr'], start_time: start_time, granularity: 'TOTAL')
      expect(stats.first.id).to eq('d9qr')
      expect(stats.first.promoted_account_follows).to eq([59])
    end
  end

  describe '#funding_instruments_stats' do
    let(:start_time) { '2013-04-01T00:00:00Z' }
    before do
      stub_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/funding_instruments')
        .with(query: {granularity: 'DAY', start_time: start_time, funding_instrument_ids: 'e25e'}).to_return(body: fixture('funding_instruments_stats.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'requests resources' do
      @client.funding_instruments_stats('5gvk9h', ['e25e'], start_time: start_time, granularity: 'DAY')
      expect(a_get('https://ads-api.twitter.com/0/stats/accounts/5gvk9h/funding_instruments').with(query: {granularity: 'DAY', start_time: start_time, funding_instrument_ids: 'e25e'})).to have_been_made
    end

    it 'gets the right resource' do
      stats = @client.funding_instruments_stats('5gvk9h', ['e25e'], start_time: start_time, granularity: 'DAY')
      expect(stats.first.id).to eq('e25e')
      expect(stats.first.promoted_tweet_timeline_clicks).to eq([65, 75, 81])
    end
  end
end
