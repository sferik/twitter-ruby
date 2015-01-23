require 'helper'

describe Twitter::Streaming::Envelope do
  describe '#message' do
    it 'returns the message as a data object' do
      data = {for_user: 1_234, message: {friends: []}}
      envelope = Twitter::Streaming::Envelope.new(data)
      expect(envelope.message).to be_a Twitter::Streaming::FriendList
    end
  end
end
