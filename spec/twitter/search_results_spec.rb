require 'helper'

describe Twitter::SearchResults do
  describe '#each' do
    before do
      @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
      stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '100'}).to_return(body: fixture('search.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '3', include_entities: '1', max_id: '414071361066532863'}).to_return(body: fixture('search2.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resources' do
      @client.search('#freebandnames').each {}
      expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '100'})).to have_been_made
      expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '3', include_entities: '1', max_id: '414071361066532863'})).to have_been_made
    end
    it 'iterates' do
      count = 0
      search_results = @client.search('#freebandnames')
      search_results.each { count += 1 }
      expect(count).to eq(6)
      expect(search_results.rate_limit).to be_a(Twitter::RateLimit)
    end
    it 'passes through parameters to the next request' do
      stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '100'}).to_return(body: fixture('search.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '3', include_entities: '1', max_id: '414071361066532863'}).to_return(body: fixture('search2.json'), headers: {content_type: 'application/json; charset=utf-8'})
      @client.search('#freebandnames', since_id: 414_071_360_078_878_542).each {}
      expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '100'})).to have_been_made
      expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '3', include_entities: '1', max_id: '414071361066532863'})).to have_been_made
    end
    context 'with start' do
      it 'iterates' do
        count = 0
        @client.search('#freebandnames').each(5) { count += 1 }
        expect(count).to eq(1)
      end
    end
  end
end
