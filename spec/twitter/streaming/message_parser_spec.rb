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
  end
end
