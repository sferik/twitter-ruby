require 'helper'

describe Twitter::REST::Search do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#search' do
    context 'without count specified' do
      before do
        stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '100'}).to_return(body: fixture('search.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.search('#freebandnames')
        expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '100'})).to have_been_made
      end
      it 'returns recent Tweets related to a query with images and videos embedded' do
        search = @client.search('#freebandnames')
        expect(search).to be_a Twitter::SearchResults
        expect(search.first).to be_a Twitter::Tweet
        expect(search.first.text).to eq('@Just_Reboot #FreeBandNames mono surround')
      end
    end
    context 'with count specified' do
      before do
        stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '3'}).to_return(body: fixture('search.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.search('#freebandnames', count: 3)
        expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '3'})).to have_been_made
      end
      it 'returns recent Tweets related to a query with images and videos embedded' do
        search = @client.search('#freebandnames', count: 3)
        expect(search).to be_a Twitter::SearchResults
        expect(search.first).to be_a Twitter::Tweet
        expect(search.first.text).to eq('@Just_Reboot #FreeBandNames mono surround')
      end
    end
  end
end
