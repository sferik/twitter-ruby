require 'helper'

describe Twitter::Ads::PromotedTweets do
  let(:account_id) {'hkk5'}
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#promoted_tweets' do
    before do
      stub_get("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets").to_return(body: fixture('promoted_tweets.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.promoted_tweets(account_id)
      expect(a_get("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets")).to have_been_made
    end
    it 'gets the right resourcse' do
      promoted_tweets = @client.promoted_tweets(account_id)
      expect(promoted_tweets.map(&:id)).to eq(['n4zr'])
    end
  end

  describe '#promote_tweet' do
    let(:args) do
      {
        tweet_ids: '161604950378561536',
        line_item_id: '6zva',
      }
    end
    before do
      stub_post("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets")
        .with(body: args).to_return(body: fixture('promoted_tweets_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'creates a promoted tweet' do
      promoted_tweets = @client.promote_tweet(account_id, '6zva', '161604950378561536')
      expect(promoted_tweets.first).to be_a Twitter::PromotedTweet
      expect(promoted_tweets.first.id).to eq('r9z9')
    end
  end

  describe '#destroy_promote_tweet' do
    before do
      stub_delete("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets/r9z9")
        .to_return(body: fixture('promoted_tweets_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'deletes a promoted tweet' do
      @client.destroy_promoted_tweet(account_id, 'r9z9')
      expect(a_delete("https://ads-api.twitter.com/0/accounts/#{account_id}/promoted_tweets/r9z9")).to have_been_made
    end
  end

  describe '#tweet' do
    let(:status) { "Maybe he'll finally find his keys. #peterfalk" }
    let(:expected) do
      {
        status: status,
      }
    end
    before do
      stub_post("https://ads-api.twitter.com/0/accounts/#{account_id}/tweet")
        .with(body: expected).to_return(body: fixture('tweet.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'creates the tweet' do
      tweet = @client.tweet(account_id, status)
      expect(a_post("https://ads-api.twitter.com/0/accounts/#{account_id}/tweet").with(body: expected)).to have_been_made
      expect(tweet).to be_a(Twitter::Tweet)
      expect(tweet.text).to eq(status)
    end
  end
end
