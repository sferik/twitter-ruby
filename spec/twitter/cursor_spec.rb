require 'helper'
require 'shared_examples_for_enumerables'

describe Twitter::Cursor do
  let(:client) { Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS') }

  subject { client.follower_ids('sferik') }

  describe 'Enumeration Methods' do
    it_behaves_like 'an enumerable'

    before do
      stub_get('/1.1/followers/ids.json').with(query: {cursor: '-1', screen_name: 'sferik'}).to_return(body: fixture('ids_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_get('/1.1/followers/ids.json').with(query: {cursor: '1305102810874389703', screen_name: 'sferik'}).to_return(body: fixture('ids_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    [:each, :each_page, :each_page_with_cursor].each do |method|
      it 'requests the correct resources' do
        subject.send(method) {}
        expect(a_get('/1.1/followers/ids.json').with(query: {cursor: '-1', screen_name: 'sferik'})).to have_been_made
        expect(a_get('/1.1/followers/ids.json').with(query: {cursor: '1305102810874389703', screen_name: 'sferik'})).to have_been_made
      end
    end

    describe '#each_page_with_cursor' do
      it_behaves_like 'an enumerable method', :each_page_with_cursor

      it 'yields an enumerable and cursor' do
        subject.each_page_with_cursor do |enumerable, cursor|
          expect(enumerable).to be_an(Enumerable)
          expect(cursor).to be_a(Twitter::Cursor)
        end
      end
    end
  end

  describe '#rate_limit' do
    before do
      stub_get('/1.1/followers/ids.json').with(query: {cursor: '-1', screen_name: 'sferik'}).to_return(
        body: fixture('ids_list.json'),
        headers: {
          'content_type'           => 'application/json; charset=utf-8',
          'X-Rate-Limit-Limit'     => '15',
          'X-Rate-Limit-Remaining' => '1',
          'X-Rate-Limit-Reset'     => Time.now + 10 * 60})

      stub_get('/1.1/followers/ids.json').with(query: {cursor: '1305102810874389703', screen_name: 'sferik'}).to_return(
        body: fixture('ids_list2.json'),
        headers: {
          'content_type'           => 'application/json; charset=utf-8',
          'X-Rate-Limit-Limit'     => '15',
          'X-Rate-Limit-Remaining' => '0',
          'X-Rate-Limit-Reset'     => Time.now + 10 * 60})
    end
    it 'returns a rate limit object' do
      cursor = subject
      expect(cursor.rate_limit).to be_a(Twitter::RateLimit)
    end
    context 'when a new request is made' do
      it 'returns an updated rate limit' do
        cursor = subject
        expect { cursor.take(5) }.to change { cursor.rate_limit.remaining }.from(1).to(0)
      end
    end
  end
end
