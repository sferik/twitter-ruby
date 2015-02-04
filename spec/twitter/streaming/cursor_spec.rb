require 'helper'

describe Twitter::Cursor do
  before do
    @client = Twitter::Streaming::Control.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS', control_uri: '/control')
    stub_post('/control/friends/ids.json', Twitter::Streaming::Control).with(body: {cursor: '-1', screen_name: 'sferik'}).to_return(body: fixture('site_stream_friends_ids.json'), headers: {content_type: 'application/json; charset=utf-8'})
    stub_post('/control/friends/ids.json', Twitter::Streaming::Control).with(body: {cursor: '1305102810874389703', screen_name: 'sferik'}).to_return(body: fixture('site_stream_friends_ids2.json'), headers: {content_type: 'application/json; charset=utf-8'})
  end

  describe '#user' do
    it 'returns basic information about the streaming user' do
      friends = @client.friend_ids('sferik')
      expect(friends.user).to be_a Twitter::Streaming::User
    end
  end

  describe '#each' do
    it 'requests the correct resources' do
      @client.friend_ids('sferik').each {}
      expect(a_post('/control/friends/ids.json', Twitter::Streaming::Control).with(body: {cursor: '-1', screen_name: 'sferik'})).to have_been_made
      expect(a_post('/control/friends/ids.json', Twitter::Streaming::Control).with(body: {cursor: '1305102810874389703', screen_name: 'sferik'})).to have_been_made
    end
    it 'iterates' do
      count = 0
      @client.friend_ids('sferik').each { count += 1 }
      expect(count).to eq(6)
    end
    context 'with start' do
      it 'iterates' do
        count = 0
        @client.friend_ids('sferik').each(5) { count += 1 }
        expect(count).to eq(1)
      end
    end
  end
end
