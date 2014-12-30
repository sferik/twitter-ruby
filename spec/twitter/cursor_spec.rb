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

    [:each, :each_page].each do |method|
      it 'requests the correct resources' do
        subject.send(method) {}
        expect(a_get('/1.1/followers/ids.json').with(query: {cursor: '-1', screen_name: 'sferik'})).to have_been_made
        expect(a_get('/1.1/followers/ids.json').with(query: {cursor: '1305102810874389703', screen_name: 'sferik'})).to have_been_made
      end
    end
  end
end
