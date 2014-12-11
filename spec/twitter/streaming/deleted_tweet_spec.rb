require 'helper'

describe Twitter::Streaming::DeletedTweet do
  describe '#==' do
    it 'returns true when objects IDs are the same' do
      deleted_tweet = Twitter::Streaming::DeletedTweet.new(id: 1)
      other = Twitter::Streaming::DeletedTweet.new(id: 1)
      expect(deleted_tweet == other).to be true
    end
    it 'returns false when objects IDs are different' do
      deleted_tweet = Twitter::Streaming::DeletedTweet.new(id: 1)
      other = Twitter::Streaming::DeletedTweet.new(id: 2)
      expect(deleted_tweet == other).to be false
    end
    it 'returns false when classes are different' do
      deleted_tweet = Twitter::Streaming::DeletedTweet.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(deleted_tweet == other).to be false
    end
  end
end
