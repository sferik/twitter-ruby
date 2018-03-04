require 'helper'

describe Twitter::DirectMessage do
  before do
    @old_stderr = $stderr
    $stderr = StringIO.new
  end

  after do
    $stderr = @old_stderr
  end

  describe '#==' do
    it 'returns true when objects IDs are the same' do
      direct_message = Twitter::DirectMessage.new(id: 1, text: 'foo')
      other = Twitter::DirectMessage.new(id: 1, text: 'bar')
      expect(direct_message == other).to be true
    end
    it 'returns false when objects IDs are different' do
      direct_message = Twitter::DirectMessage.new(id: 1)
      other = Twitter::DirectMessage.new(id: 2)
      expect(direct_message == other).to be false
    end
    it 'returns false when classes are different' do
      direct_message = Twitter::DirectMessage.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(direct_message == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created_at is set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(direct_message.created_at).to be_a Time
      expect(direct_message.created_at).to be_utc
    end
    it 'returns nil when created_at is not set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(direct_message.created_at).to be_nil
    end
  end

  describe '#created?' do
    it 'returns true when created_at is set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(direct_message.created?).to be true
    end
    it 'returns false when created_at is not set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(direct_message.created?).to be false
    end
  end

  describe '#entities?' do
    it 'returns true if there are entities set' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [10, 33],
        },
      ]
      tweet = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: urls_array})
      expect(tweet.entities?).to be true
    end
    it 'returns false if there are blank lists of entities set' do
      tweet = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: []})
      expect(tweet.entities?).to be false
    end
    it 'returns false if there are no entities set' do
      tweet = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(tweet.entities?).to be false
    end
  end

  describe '#recipient' do
    it 'returns a User when recipient is set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, recipient: {id: 7_505_382})
      expect(direct_message.recipient).to be_a Twitter::User
    end
    it 'returns nil when recipient is not set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(direct_message.recipient).to be_nil
    end
  end

  describe '#recipient?' do
    it 'returns true when recipient is set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, recipient: {id: 7_505_382})
      expect(direct_message.recipient?).to be true
    end
    it 'returns false when recipient is not set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(direct_message.recipient?).to be false
    end
  end

  describe '#sender' do
    it 'returns a User when sender is set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, sender: {id: 7_505_382})
      expect(direct_message.sender).to be_a Twitter::User
    end
    it 'returns nil when sender is not set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(direct_message.sender).to be_nil
    end
  end

  describe '#sender?' do
    it 'returns true when sender is set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, sender: {id: 7_505_382})
      expect(direct_message.sender?).to be true
    end
    it 'returns false when sender is not set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(direct_message.sender?).to be false
    end
  end

  describe '#hashtags' do
    it 'returns an array of Entity::Hashtag when entities are set' do
      hashtags_array = [
        {
          text: 'twitter',
          indices: [10, 33],
        },
      ]
      hashtags = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {hashtags: hashtags_array}).hashtags
      expect(hashtags).to be_an Array
      expect(hashtags.first).to be_a Twitter::Entity::Hashtag
      expect(hashtags.first.indices).to eq([10, 33])
      expect(hashtags.first.text).to eq('twitter')
    end
    it 'is empty when not set' do
      hashtags = Twitter::DirectMessage.new(id: 1_825_786_345).hashtags
      expect(hashtags).to be_empty
    end
  end

  describe '#media' do
    it 'returns media' do
      media = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {media: [{id: 1, type: 'photo'}]}).media
      expect(media).to be_an Array
      expect(media.first).to be_a Twitter::Media::Photo
    end
    it 'is empty when not set' do
      media = Twitter::DirectMessage.new(id: 1_825_786_345).media
      expect(media).to be_empty
    end
  end

  describe '#symbols' do
    it 'returns an array of Entity::Symbol when symbols are set' do
      symbols_array = [
        {text: 'PEP', indices: [114, 118]},
        {text: 'COKE', indices: [128, 133]},
      ]
      symbols = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {symbols: symbols_array}).symbols
      expect(symbols).to be_an Array
      expect(symbols.size).to eq(2)
      expect(symbols.first).to be_a Twitter::Entity::Symbol
      expect(symbols.first.indices).to eq([114, 118])
      expect(symbols.first.text).to eq('PEP')
    end
    it 'is empty when not set' do
      symbols = Twitter::DirectMessage.new(id: 1_825_786_345).symbols
      expect(symbols).to be_empty
    end
  end

  describe '#uris' do
    it 'returns an array of Entity::URIs when entities are set' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [10, 33],
        },
      ]
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: urls_array})
      expect(direct_message.uris).to be_an Array
      expect(direct_message.uris.first).to be_a Twitter::Entity::URI
      expect(direct_message.uris.first.indices).to eq([10, 33])
      expect(direct_message.uris.first.display_uri).to be_a String
      expect(direct_message.uris.first.display_uri).to eq('example.com/expanded...')
    end
    it 'is empty when not set' do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)
      expect(direct_message.uris).to be_empty
    end
    it 'can handle strange urls' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://with_underscore.example.com/expanded',
          display_url: 'with_underscore.example.com/expanded...',
          indices: [10, 33],
        },
      ]
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: urls_array})
      uri = direct_message.uris.first
      expect { uri.url }.not_to raise_error
      expect { uri.expanded_url }.not_to raise_error
      expect { uri.display_url }.not_to raise_error
    end
  end

  describe '#user_mentions' do
    it 'returns an array of Entity::UserMention when entities are set' do
      user_mentions_array = [
        {
          screen_name: 'sferik',
          name: 'Erik Michaels-Ober',
          id_str: '7_505_382',
          indices: [0, 6],
          id: 7_505_382,
        },
      ]
      user_mentions = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {user_mentions: user_mentions_array}).user_mentions
      expect(user_mentions).to be_an Array
      expect(user_mentions.first).to be_a Twitter::Entity::UserMention
      expect(user_mentions.first.indices).to eq([0, 6])
      expect(user_mentions.first.id).to eq(7_505_382)
    end
    it 'is empty when not set' do
      user_mentions = Twitter::DirectMessage.new(id: 1_825_786_345).user_mentions
      expect(user_mentions).to be_empty
    end
  end
end
