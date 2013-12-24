require 'helper'

describe Twitter::REST::API::Search do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :access_token => 'AT', :access_token_secret => 'AS')
  end

  describe '#search' do
    before do
      stub_get('/1.1/search/tweets.json').with(:query => {:q => '#freebandnames'}).to_return(:body => fixture('search.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.search('#freebandnames')
      expect(a_get('/1.1/search/tweets.json').with(:query => {:q => '#freebandnames'})).to have_been_made
    end
    it 'returns recent Tweets related to a query with images and videos embedded' do
      search = @client.search('#freebandnames')
      expect(search).to be_a Twitter::SearchResults
      expect(search.first).to be_a Twitter::Tweet
      expect(search.first.text).to eq('@Just_Reboot #FreeBandNames mono surround')
    end
    context 'when search API responds a malformed result' do
      before do
        stub_get('/1.1/search/tweets.json').with(:query => {:q => '#freebandnames'}).to_return(:body => fixture('search_malformed.json'), :headers => {:content_type => 'application/json; charset=utf-8'})
      end
      it 'returns an empty array' do
        search = @client.search('#freebandnames')
        expect(search.to_a).to be_an Array
        expect(search.to_a).to be_empty
      end
    end
  end

end
