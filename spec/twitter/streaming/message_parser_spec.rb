require 'helper'

describe Twitter::Streaming::MessageParser do
  subject do
    Twitter::Streaming::MessageParser
  end

  describe '.parse' do
    it 'returns a tweet if the data has an id' do
      data = {id: 1}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Tweet
      expect(object.id).to eq(1)
    end
    it 'returns an event if the data has an event' do
      data = {event: 'favorite', source: {id: 1}, target: {id: 2}, target_object: {id: 1}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::Event
      expect(object.name).to eq(:favorite)
      expect(object.source).to be_a Twitter::User
      expect(object.source.id).to eq(1)
      expect(object.target).to be_a Twitter::User
      expect(object.target.id).to eq(2)
      expect(object.target_object).to be_a Twitter::Tweet
      expect(object.target_object.id).to eq(1)
    end
    it 'returns a direct message if the data has a direct_message' do
      data = {direct_message: {id: 1}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::DirectMessage
      expect(object.id).to eq(1)
    end
    it 'returns a friend list if the data has friends' do
      data = {friends: [1]}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::FriendList
      expect(object.first).to eq(1)
    end
    it 'returns a deleted tweet if the data has a deleted status' do
      data = {delete: {status: {id: 1}}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::DeletedTweet
      expect(object.id).to eq(1)
    end
    it 'returns a stall warning if the data has a warning' do
      data = {warning: {code: 'FALLING_BEHIND'}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::StallWarning
      expect(object.code).to eq('FALLING_BEHIND')
    end
    it 'returns a disconnect if the data has a disconnect' do
      data = {disconnect: {code: 4, stream_name: '', reason: ''}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::Disconnect
      expect(object.code).to eq(4)
    end
    it 'returns a scrub geo if the data has a scrub geo message' do
      data = {scrub_geo: {user_id: 14_090_452, up_to_status_id: 23_260_136_625}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::ScrubGeo
      expect(object.user_id).to eq(14_090_452)
    end
    it 'returns a limit if the data has a limit message' do
      data = {limit: {track: 1_234}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::Limit
      expect(object.track).to eq(1_234)
    end
    it 'returns a status withheld if the data has a status withheld' do
      data = {status_withheld: {id: 1_234_567_890, user_id: 123_456}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::StatusWithheld
      expect(object.user_id).to eq(123_456)
    end
    it 'returns a user withheld if the data has a user withheld' do
      data = {user_withheld: {id: 1_234_567_890}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::UserWithheld
      expect(object.id).to eq(1_234_567_890)
    end
    it 'returns a too many follows warning if the data has a warning' do
      data = {warning: {code: 'FOLLOWS_OVER_LIMIT'}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::TooManyFollowsWarning
      expect(object.code).to eq('FOLLOWS_OVER_LIMIT')
    end
    it 'returns an envelope when the data is a site stream message' do
      data = {for_user: 1_234, message: {friends: []}}
      object = subject.parse(data)
      expect(object).to be_a Twitter::Streaming::Envelope
      expect(object.for_user).to eq(1_234)
    end
  end
end
