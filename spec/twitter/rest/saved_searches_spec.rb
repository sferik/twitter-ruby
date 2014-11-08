require 'helper'

describe Twitter::REST::SavedSearches do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#saved_searches' do
    context 'with ids passed' do
      before do
        stub_get('/1.1/saved_searches/show/16129012.json').to_return(body: fixture('saved_search.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/saved_searches/show/16129013.json').to_return(body: fixture('saved_search.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.saved_searches(16_129_012, 16_129_013)
        expect(a_get('/1.1/saved_searches/show/16129012.json')).to have_been_made
        expect(a_get('/1.1/saved_searches/show/16129013.json')).to have_been_made
      end
      it 'returns an array of saved searches' do
        saved_searches = @client.saved_searches(16_129_012, 16_129_013)
        expect(saved_searches).to be_an Array
        expect(saved_searches.size).to eq(2)
        expect(saved_searches.first).to be_a Twitter::SavedSearch
        expect(saved_searches.first.name).to eq('twitter')
        expect(saved_searches.last).to be_a Twitter::SavedSearch
        expect(saved_searches.last.name).to eq('twitter')
      end
    end
    context 'without ids passed' do
      before do
        stub_get('/1.1/saved_searches/list.json').to_return(body: fixture('saved_searches.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.saved_searches
        expect(a_get('/1.1/saved_searches/list.json')).to have_been_made
      end
      it 'returns the saved search queries for the authenticated user' do
        saved_searches = @client.saved_searches
        expect(saved_searches).to be_an Array
        expect(saved_searches.first).to be_a Twitter::SavedSearch
        expect(saved_searches.first.name).to eq('twitter')
      end
    end
  end

  describe '#saved_search' do
    before do
      stub_get('/1.1/saved_searches/show/16129012.json').to_return(body: fixture('saved_search.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.saved_search(16_129_012)
      expect(a_get('/1.1/saved_searches/show/16129012.json')).to have_been_made
    end
    it 'returns a saved search' do
      saved_search = @client.saved_search(16_129_012)
      expect(saved_search).to be_a Twitter::SavedSearch
      expect(saved_search.name).to eq('twitter')
    end
  end

  describe '#create_saved_search' do
    before do
      stub_post('/1.1/saved_searches/create.json').with(body: {query: 'twitter'}).to_return(body: fixture('saved_search.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.create_saved_search('twitter')
      expect(a_post('/1.1/saved_searches/create.json').with(body: {query: 'twitter'})).to have_been_made
    end
    it 'returns the created saved search' do
      saved_search = @client.create_saved_search('twitter')
      expect(saved_search).to be_a Twitter::SavedSearch
      expect(saved_search.name).to eq('twitter')
    end
  end

  describe '#destroy_saved_search' do
    before do
      stub_post('/1.1/saved_searches/destroy/16129012.json').to_return(body: fixture('saved_search.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_post('/1.1/saved_searches/destroy/16129013.json').to_return(body: fixture('saved_search.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.destroy_saved_search(16_129_012, 16_129_013)
      expect(a_post('/1.1/saved_searches/destroy/16129012.json')).to have_been_made
      expect(a_post('/1.1/saved_searches/destroy/16129013.json')).to have_been_made
    end
    it 'returns an array of deleted saved searches' do
      saved_searches = @client.destroy_saved_search(16_129_012, 16_129_013)
      expect(saved_searches).to be_an Array
      expect(saved_searches.size).to eq(2)
      expect(saved_searches.first).to be_a Twitter::SavedSearch
      expect(saved_searches.first.name).to eq('twitter')
      expect(saved_searches.last).to be_a Twitter::SavedSearch
      expect(saved_searches.last.name).to eq('twitter')
    end
  end
end
