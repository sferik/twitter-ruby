# coding: utf-8
require 'helper'

describe Twitter::REST::Favorites do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :access_token => 'AT', :access_token_secret => 'AS')
  end

  describe '#favorites' do
    context 'with a screen name passed' do
      before do
        stub_get('/1.1/favorites/list.json').with(:query => {:screen_name => 'sferik'}).to_return(:body => fixture('user_timeline.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.favorites('sferik')
        expect(a_get('/1.1/favorites/list.json').with(:query => {:screen_name => 'sferik'})).to have_been_made
      end
      it 'returns the 20 most recent favorite Tweets for the authenticating user or user specified by the ID parameter' do
        favorites = @client.favorites('sferik')
        expect(favorites).to be_an Array
        expect(favorites.first).to be_a Twitter::Tweet
        expect(favorites.first.user.id).to eq(7_505_382)
      end
      context 'with a URI object passed' do
        it 'requests the correct resource' do
          user = URI.parse('https://twitter.com/sferik')
          @client.favorites(user)
          expect(a_get('/1.1/favorites/list.json').with(:query => {:screen_name => 'sferik'})).to have_been_made
        end
      end
      context 'with a URI string passed' do
        it 'requests the correct resource' do
          @client.favorites('https://twitter.com/sferik')
          expect(a_get('/1.1/favorites/list.json').with(:query => {:screen_name => 'sferik'})).to have_been_made
        end
      end
    end
    context 'without arguments passed' do
      before do
        stub_get('/1.1/favorites/list.json').to_return(:body => fixture('user_timeline.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.favorites
        expect(a_get('/1.1/favorites/list.json')).to have_been_made
      end
      it 'returns the 20 most recent favorite Tweets for the authenticating user or user specified by the ID parameter' do
        favorites = @client.favorites
        expect(favorites).to be_an Array
        expect(favorites.first).to be_a Twitter::Tweet
        expect(favorites.first.user.id).to eq(7_505_382)
      end
    end
  end

  describe '#unfavorite' do
    before do
      stub_post('/1.1/favorites/destroy.json').with(:body => {:id => '25938088801'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.unfavorite(25_938_088_801)
      expect(a_post('/1.1/favorites/destroy.json').with(:body => {:id => '25938088801'})).to have_been_made
    end
    it 'returns an array of un-favorited Tweets' do
      tweets = @client.unfavorite(25_938_088_801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.unfavorite(tweet)
        expect(a_post('/1.1/favorites/destroy.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.unfavorite('https://twitter.com/sferik/status/25938088801')
        expect(a_post('/1.1/favorites/destroy.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.unfavorite(tweet)
        expect(a_post('/1.1/favorites/destroy.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
  end

  describe '#favorite' do
    before do
      stub_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.favorite(25_938_088_801)
      expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
    end
    it 'returns an array of favorited Tweets' do
      tweets = @client.favorite(25_938_088_801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
    end
    context 'already favorited' do
      before do
        stub_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'}).to_return(:status => 403, :body => fixture('already_favorited.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'does not raises an error' do
        expect { @client.favorite(25_938_088_801) }.not_to raise_error
      end
    end
    context 'tweet does not exist' do
      before do
        stub_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'}).to_return(:status => 404, :body => fixture('status_not_found.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'does not raise an error' do
        expect { @client.favorite(25_938_088_801) }.not_to raise_error
      end
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.favorite(tweet)
        expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.favorite('https://twitter.com/sferik/status/25938088801')
        expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.favorite(tweet)
        expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
  end

  describe '#favorite!' do
    before do
      stub_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'}).to_return(:body => fixture('status.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.favorite!(25_938_088_801)
      expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
    end
    it 'returns an array of favorited Tweets' do
      tweets = @client.favorite!(25_938_088_801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("\"I hope you'll keep...building bonds of friendship that will enrich your lives &amp; enrich our world\" —FLOTUS in China, http://t.co/fxmuQN9JL9")
    end
    context 'forbidden' do
      before do
        stub_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'}).to_return(:status => 403, :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises a Forbidden error' do
        expect { @client.favorite!(25_938_088_801) }.to raise_error(Twitter::Error::Forbidden)
      end
    end
    context 'already favorited' do
      before do
        stub_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'}).to_return(:status => 403, :body => fixture('already_favorited.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises an AlreadyFavorited error' do
        expect { @client.favorite!(25_938_088_801) }.to raise_error(Twitter::Error::AlreadyFavorited)
      end
    end
    context 'tweet does not exist' do
      before do
        stub_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'}).to_return(:status => 404, :body => fixture('status_not_found.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'raises a NotFound error' do
        expect { @client.favorite!(25_938_088_801) }.to raise_error(Twitter::Error::NotFound)
      end
    end
    context 'with a URI object passed' do
      it 'requests the correct resource' do
        tweet = URI.parse('https://twitter.com/sferik/status/25938088801')
        @client.favorite!(tweet)
        expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a URI string passed' do
      it 'requests the correct resource' do
        @client.favorite!('https://twitter.com/sferik/status/25938088801')
        expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
    context 'with a Tweet passed' do
      it 'requests the correct resource' do
        tweet = Twitter::Tweet.new(:id => 25_938_088_801)
        @client.favorite!(tweet)
        expect(a_post('/1.1/favorites/create.json').with(:body => {:id => '25938088801'})).to have_been_made
      end
    end
  end

end
