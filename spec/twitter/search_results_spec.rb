require 'helper'
require 'shared_examples_for_enumerables'

describe Twitter::SearchResults do
  let(:client) { Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS') }

  it_behaves_like 'an enumerable' do
    let(:enumerable) { client.search('#freebandnames')  }

    before do
      stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '100'}).to_return(body: fixture('search.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '3', include_entities: '1', max_id: '414071361066532863'}).to_return(body: fixture('search2.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    [:each, :each_page].each do |method|
      it 'requests the correct resources' do
        client.search('#freebandnames').send(method) {}
        expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '100'})).to have_been_made
        expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', count: '3', include_entities: '1', max_id: '414071361066532863'})).to have_been_made
      end

      it 'passes through parameters to the next request' do
        stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '100'}).to_return(body: fixture('search.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '3', include_entities: '1', max_id: '414071361066532863'}).to_return(body: fixture('search2.json'), headers: {content_type: 'application/json; charset=utf-8'})
        client.search('#freebandnames', since_id: 414_071_360_078_878_542).send(method) {}
        expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '100'})).to have_been_made
        expect(a_get('/1.1/search/tweets.json').with(query: {q: '#freebandnames', since_id: '414071360078878542', count: '3', include_entities: '1', max_id: '414071361066532863'})).to have_been_made
      end
    end
  end
end
