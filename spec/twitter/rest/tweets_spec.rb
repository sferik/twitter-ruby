# coding: utf-8
require 'helper'

describe Twitter::REST::Tweets do
  before do
    @client = Twitter::REST::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :access_token => 'AT', :access_token_secret => 'AS')
  end

  describe '#retweets' do
    before do
      stub_get('/1.1/statuses/retweets/25938088801.json').to_return(:body => fixture('retweets.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    context 'with a tweet ID passed' do
      it 'requests the correct resource' do
        @client.retweets(25_938_088_801)
        expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
      end
      it 'returns up to 100 of the first retweets of a given tweet' do
        tweets = @client.retweets(25_938_088_801)
        expect(tweets).to be_an Array
        expect(tweets.first).to be_a Twitter::Tweet
        expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      end
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.retweets(tweet)
        expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.retweets('https://twitter.com/sferik/status/25938088801')
        expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.retweets(tweet)
        expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
      end
    end
  end

  describe '#retweeters_of' do
    context 'with ids_only passed' do
      context 'with a tweet ID passed' do
        before do
          stub_get('/1.1/statuses/retweets/25938088801.json').to_return(:body => fixture('retweets.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
        end
        it 'requests the correct resource' do
          @client.retweeters_of(25_938_088_801, :ids_only => true)
          expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
        end
        it 'returns an array of numeric user IDs of retweeters of a Tweet' do
          ids = @client.retweeters_of(25_938_088_801, :ids_only => true)
          expect(ids).to be_an Array
          expect(ids.first).to eq(7_505_382)
        end
      end
    end
    context 'without ids_only passed' do
      before do
        stub_get('/1.1/statuses/retweets/25938088801.json').to_return(:body => fixture('retweets.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.retweeters_of(25_938_088_801)
        expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
      end
      it 'returns an array of user of retweeters of a Tweet' do
        users = @client.retweeters_of(25_938_088_801)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq(7_505_382)
      end
      context 'with a URI object passed' do
        it 'requests the correct resource' do
          tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
          @client.retweeters_of(tweet)
          expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
        end
      end
      context 'with a URI string passed' do
        it 'requests the correct resource' do
          @client.retweeters_of('https://twitter.com/sferik/status/25938088801')
          expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
        end
      end
      context 'with a Tweet passed' do
        it 'requests the correct resource' do
          tweet = Twitter::Tweet.new(:id => 25_938_088_801)
          @client.retweeters_of(tweet)
          expect(a_get('/1.1/statuses/retweets/25938088801.json')).to have_been_made
        end
      end
    end
  end

  describe '#status' do
    before do
      stub_get('/1.1/statuses/show/25938088801.json').to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.status(25_938_088_801)
      expect(a_get('/1.1/statuses/show/25938088801.json')).to have_been_made
    end
    it 'returns a Tweet' do
      tweet = @client.status(25_938_088_801)
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.status(tweet)
        expect(a_get('/1.1/statuses/show/25938088801.json')).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.status('https://twitter.com/sferik/status/25938088801')
        expect(a_get('/1.1/statuses/show/25938088801.json')).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.status(tweet)
        expect(a_get('/1.1/statuses/show/25938088801.json')).to have_been_made
      end
    end
  end

  describe '#statuses' do
    before do
      stub_post('/1.1/statuses/lookup.json').with(:body => {:id => '25938088801,91151181040201728'}).to_return(:body => fixture('statuses.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.statuses(25_938_088_801, 91_151_181_040_201_728)
      expect(a_post('/1.1/statuses/lookup.json').with(:body => {:id => '25938088801,91151181040201728'})).to have_been_made
    end
    it 'returns an array of Tweets' do
      tweets = @client.statuses(25_938_088_801, 91_151_181_040_201_728)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq('Happy Birthday @imdane. Watch out for those @rally pranksters!')
    end
    context 'with URI objects passed' do
      it 'requests the correct resource' do
        @client.statuses(URI.parse('https://twitter.com/sferik/status/25938088801'), URI.parse('https://twitter.com/sferik/status/91151181040201728'))
        expect(a_post('/1.1/statuses/lookup.json').with(:body => {:id => '25938088801,91151181040201728'})).to have_been_made
      end
    end
    context 'with URI strings passed' do
      it 'requests the correct resource' do
        @client.statuses('https://twitter.com/sferik/status/25938088801', 'https://twitter.com/sferik/status/91151181040201728')
        expect(a_post('/1.1/statuses/lookup.json').with(:body => {:id => '25938088801,91151181040201728'})).to have_been_made
      end
    end
    context 'with Tweets passed' do
      it 'requests the correct resource' do
        @client.statuses(Twitter::Tweet.new(:id => 25_938_088_801), Twitter::Tweet.new(:id => 91_151_181_040_201_728))
        expect(a_post('/1.1/statuses/lookup.json').with(:body => {:id => '25938088801,91151181040201728'})).to have_been_made
      end
    end
  end

  describe '#destroy_status' do
    before do
      stub_post('/1.1/statuses/destroy/25938088801.json').to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.destroy_status(25_938_088_801)
      expect(a_post('/1.1/statuses/destroy/25938088801.json')).to have_been_made
    end
    it 'returns an array of Tweets' do
      tweets = @client.destroy_status(25_938_088_801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.destroy_status(tweet)
        expect(a_post('/1.1/statuses/destroy/25938088801.json')).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.destroy_status('https://twitter.com/sferik/status/25938088801')
        expect(a_post('/1.1/statuses/destroy/25938088801.json')).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.destroy_status(tweet)
        expect(a_post('/1.1/statuses/destroy/25938088801.json')).to have_been_made
      end
    end
  end

  describe '#update' do
    before do
      stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9"}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
      expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9"})).to have_been_made
    end
    it 'returns a Tweet' do
      tweet = @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
    end
    context 'already posted' do
      before do
        stub_post('/1.1/statuses/update.json').to_return(:status => 403, :body => fixture('already_posted.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
        stub_get('/1.1/statuses/user_timeline.json').with(:query => {:count => 1}).to_return(:body => fixture('statuses.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resources' do
        @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9"})).to have_been_made
        expect(a_get('/1.1/statuses/user_timeline.json').with(:query => {:count => 1})).to have_been_made
      end
      it 'returns a Tweet' do
        tweet = @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
        expect(tweet).to be_a Twitter::Tweet
        expect(tweet.text).to eq('Happy Birthday @imdane. Watch out for those @rally pranksters!')
      end
    end
    context 'with an in-reply-to status' do
      before do
        @tweet = Twitter::Tweet.new(:id => 1)
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status => @tweet)
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'})).to have_been_made
      end
    end
    context 'with an in-reply-to status ID' do
      before do
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => 1)
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'})).to have_been_made
      end
    end
    context 'with a place' do
      before do
        @place = Twitter::Place.new(:woeid => 'df51dec6f4ee2b2c')
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place => @place)
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'})).to have_been_made
      end
    end
    context 'with a place ID' do
      before do
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c')
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'})).to have_been_made
      end
    end
  end

  describe '#update!' do
    before do
      stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9"}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.update!("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
      expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9"})).to have_been_made
    end
    it 'returns a Tweet' do
      tweet = @client.update!("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
    end
    context 'already posted' do
      before do
        stub_post('/1.1/statuses/update.json').to_return(:status => 403, :body => fixture('already_posted.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises an DuplicateStatus error' do
        expect { @client.update!("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9") }.to raise_error(Twitter::Error::DuplicateStatus)
      end
    end
    context 'with an in-reply-to status' do
      before do
        @tweet = Twitter::Tweet.new(:id => 1)
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update!("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status => @tweet)
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'})).to have_been_made
      end
    end
    context 'with an in-reply-to status ID' do
      before do
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update!("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => 1)
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :in_reply_to_status_id => '1'})).to have_been_made
      end
    end
    context 'with a place' do
      before do
        @place = Twitter::Place.new(:woeid => 'df51dec6f4ee2b2c')
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update!("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place => @place)
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'})).to have_been_made
      end
    end
    context 'with a place ID' do
      before do
        stub_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.update!("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c')
        expect(a_post('/1.1/statuses/update.json').with(:body => {:status => "\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", :place_id => 'df51dec6f4ee2b2c'})).to have_been_made
      end
    end
  end

  describe '#retweet' do
    before do
      stub_post('/1.1/statuses/retweet/25938088801.json').to_return(:body => fixture('retweet.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.retweet(25_938_088_801)
      expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
    end
    it 'returns an array of Tweets with retweet details embedded' do
      tweets = @client.retweet(25_938_088_801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.text).to eq("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.id).not_to eq(tweets.first.id)
    end
    context 'already retweeted' do
      before do
        stub_post('/1.1/statuses/retweet/25938088801.json').to_return(:status => 403, :body => fixture('already_retweeted.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'does not raise an error' do
        expect { @client.retweet(25_938_088_801) }.not_to raise_error
      end
    end
    context 'not found' do
      before do
        stub_post('/1.1/statuses/retweet/25938088801.json').to_return(:status => 404, :body => fixture('not_found.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'does not raise an error' do
        expect { @client.retweet(25_938_088_801) }.not_to raise_error
      end
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.retweet(tweet)
        expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.retweet('https://twitter.com/sferik/status/25938088801')
        expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.retweet(tweet)
        expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
      end
    end
  end

  describe '#retweet!' do
    before do
      stub_post('/1.1/statuses/retweet/25938088801.json').to_return(:body => fixture('retweet.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.retweet!(25_938_088_801)
      expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
    end
    it 'returns an array of Tweets with retweet details embedded' do
      tweets = @client.retweet!(25_938_088_801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.text).to eq("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.id).not_to eq(tweets.first.id)
    end
    context 'forbidden' do
      before do
        stub_post('/1.1/statuses/retweet/25938088801.json').to_return(:status => 403, :body => '{}', :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises a Forbidden error' do
        expect { @client.retweet!(25_938_088_801) }.to raise_error(Twitter::Error::Forbidden)
      end
    end
    context 'already retweeted' do
      before do
        stub_post('/1.1/statuses/retweet/25938088801.json').to_return(:status => 403, :body => fixture('already_retweeted.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises an AlreadyRetweeted error' do
        expect { @client.retweet!(25_938_088_801) }.to raise_error(Twitter::Error::AlreadyRetweeted)
      end
    end
    context 'not found' do
      before do
        stub_post('/1.1/statuses/retweet/25938088801.json').to_return(:status => 404, :body => fixture('not_found.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises a NotFound error' do
        expect { @client.retweet!(25_938_088_801) }.to raise_error(Twitter::Error::NotFound)
      end
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.retweet!(tweet)
        expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.retweet!('https://twitter.com/sferik/status/25938088801')
        expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.retweet!(tweet)
        expect(a_post('/1.1/statuses/retweet/25938088801.json')).to have_been_made
      end
    end
  end

  describe '#update_with_media' do
    before do
      stub_post('/1.1/statuses/update.json').to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      stub_request(:post, 'https://upload.twitter.com/1.1/media/upload.json').to_return(:body => fixture('upload.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    context 'a gif image' do
      it 'requests the correct resource' do
        @client.update_with_media("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", fixture('pbjt.gif'))
        expect(a_post('/1.1/statuses/update.json')).to have_been_made
      end
      it 'returns a Tweet' do
        tweet = @client.update_with_media("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", fixture('pbjt.gif'))
        expect(tweet).to be_a Twitter::Tweet
        expect(tweet.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
      end
    end
    context 'a jpe image' do
      it 'requests the correct resource' do
        @client.update_with_media('You always have options', fixture('wildcomet2.jpe'))
        expect(a_post('/1.1/statuses/update.json')).to have_been_made
      end
    end
    context 'a jpeg image' do
      it 'requests the correct resource' do
        @client.update_with_media('You always have options', fixture('me.jpeg'))
        expect(a_post('/1.1/statuses/update.json')).to have_been_made
      end
    end
    context 'a png image' do
      it 'requests the correct resource' do
        @client.update_with_media('You always have options', fixture('we_concept_bg2.png'))
        expect(a_post('/1.1/statuses/update.json')).to have_been_made
      end
    end
    context 'a Tempfile' do
      it 'requests the correct resource' do
        @client.update_with_media('You always have options', Tempfile.new('tmp'))
        expect(a_post('/1.1/statuses/update.json')).to have_been_made
      end
    end
    context 'multiple files' do
      it 'requests the correct resource' do
        media = [Tempfile.new('tmp'), fixture('pbjt.gif')]
        @client.update_with_media('You always have options', media)
        expect(a_post('/1.1/statuses/update.json')).to have_been_made
      end
    end
    context 'a mp4 video' do
      it 'requests the correct resources' do
        @client.update_with_media('You always have options', fixture('1080p.mp4'))
        expect(a_request(:post, 'https://upload.twitter.com/1.1/media/upload.json')).to have_been_made.times(3)
        expect(a_post('/1.1/statuses/update.json')).to have_been_made
      end
    end
    context 'already posted' do
      before do
        stub_post('/1.1/statuses/update.json').to_return(:status => 403, :body => fixture('already_posted.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises an DuplicateStatus error' do
        expect { @client.update_with_media("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9", fixture('pbjt.gif')) }.to raise_error(Twitter::Error::DuplicateStatus)
      end
    end
  end

  describe '#oembed' do
    before do
      stub_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'}).to_return(:body => fixture('oembed.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      stub_get('/1.1/statuses/oembed.json').with(:query => {:url => 'https://twitter.com/sferik/status/25938088801'}).to_return(:body => fixture('oembed.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.oembed(25_938_088_801)
      expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
    end
    it 'requests the correct resource when a URL is given' do
      @client.oembed('https://twitter.com/sferik/status/25938088801')
      expect(a_get('/1.1/statuses/oembed.json').with(:query => {:url => 'https://twitter.com/sferik/status/25938088801'}))
    end
    it 'returns an array of OEmbed instances' do
      oembed = @client.oembed(25_938_088_801)
      expect(oembed).to be_a Twitter::OEmbed
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.oembed(tweet)
        expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.oembed('https://twitter.com/sferik/status/25938088801')
        expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.oembed(tweet)
        expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
      end
    end
  end

  describe '#oembeds' do
    before do
      stub_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'}).to_return(:body => fixture('oembed.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.oembeds(25_938_088_801)
      expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
    end
    it 'requests the correct resource when a URL is given' do
      @client.oembeds('https://twitter.com/sferik/status/25938088801')
      expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
    end
    it 'returns an array of OEmbed instances' do
      oembeds = @client.oembeds(25_938_088_801)
      expect(oembeds).to be_an Array
      expect(oembeds.first).to be_a Twitter::OEmbed
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.oembeds(tweet)
        expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.oembeds('https://twitter.com/sferik/status/25938088801')
        expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.oembeds(tweet)
        expect(a_get('/1.1/statuses/oembed.json').with(:query => {:id => '25938088801'})).to have_been_made
      end
    end
  end

  describe '#retweeters_ids' do
    before do
      stub_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '-1'}).to_return(:body => fixture('ids_list.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.retweeters_ids(25_938_088_801)
      expect(a_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '-1'})).to have_been_made
    end
    it 'returns a collection of up to 100 user IDs belonging to users who have retweeted the tweet specified by the id parameter' do
      retweeters_ids = @client.retweeters_ids(25_938_088_801)
      expect(retweeters_ids).to be_a Twitter::Cursor
      expect(retweeters_ids.first).to eq(20_009_713)
    end
    context 'with each' do
      before do
        stub_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '1305102810874389703'}).to_return(:body => fixture('ids_list2.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.retweeters_ids(25_938_088_801).each {}
        expect(a_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '-1'})).to have_been_made
        expect(a_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '1305102810874389703'})).to have_been_made
      end
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.retweeters_ids(tweet)
        expect(a_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '-1'})).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.retweeters_ids('https://twitter.com/sferik/status/25938088801')
        expect(a_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '-1'})).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.retweeters_ids(tweet)
        expect(a_get('/1.1/statuses/retweeters/ids.json').with(:query => {:id => '25938088801', :cursor => '-1'})).to have_been_made
      end
    end
  end
end
