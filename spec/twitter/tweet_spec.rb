require 'helper'

describe Twitter::Tweet do
  before do
    @old_stderr = $stderr
    $stderr = StringIO.new
  end

  after do
    $stderr = @old_stderr
  end

  describe '#==' do
    it 'returns true when objects IDs are the same' do
      tweet = Twitter::Tweet.new(id: 1, text: 'foo')
      other = Twitter::Tweet.new(id: 1, text: 'bar')
      expect(tweet == other).to be true
    end
    it 'returns false when objects IDs are different' do
      tweet = Twitter::Tweet.new(id: 1)
      other = Twitter::Tweet.new(id: 2)
      expect(tweet == other).to be false
    end
    it 'returns false when classes are different' do
      tweet = Twitter::Tweet.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(tweet == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(tweet.created_at).to be_a Time
      expect(tweet.created_at).to be_utc
    end
    it 'returns nil when not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.created_at).to be_nil
    end
  end

  describe '#created?' do
    it 'returns true when created_at is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(tweet.created?).to be true
    end
    it 'returns false when created_at is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.created?).to be false
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
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: urls_array})
      expect(tweet.entities?).to be true
    end
    it 'returns false if there are blank lists of entities set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: []})
      expect(tweet.entities?).to be false
    end
    it 'returns false if there are no entities set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.entities?).to be false
    end
  end

  describe '#filter_level' do
    it 'returns the filter level when filter_level is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, filter_level: 'high')
      expect(tweet.filter_level).to be_a String
      expect(tweet.filter_level).to eq('high')
    end
    it 'returns nil when not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.filter_level).to be_nil
    end
  end

  describe '#full_text' do
    it 'returns the text of a Tweet' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: 'BOOSH')
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq('BOOSH')
    end
    it 'returns the text of a Tweet without a user' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: 'BOOSH', retweeted_status: {id: 28_561_922_517, text: 'BOOSH'})
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq('BOOSH')
    end
    it 'returns the full text of a retweeted Tweet' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: 'RT @sferik: BOOSH', retweeted_status: {id: 540_897_316_908_331_009, text: 'BOOSH'})
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq('RT @sferik: BOOSH')
    end
    it 'returns nil when retweeted_status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.full_text).to be_nil
    end
  end

  describe '#geo' do
    it 'returns a Twitter::Geo::Point when geo is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, geo: {id: 1, type: 'Point'})
      expect(tweet.geo).to be_a Twitter::Geo::Point
    end
    it 'returns nil when geo is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.geo).to be_nil
    end
  end

  describe '#geo?' do
    it 'returns true when geo is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, geo: {id: 1, type: 'Point'})
      expect(tweet.geo?).to be true
    end
    it 'returns false when geo is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.geo?).to be false
    end
  end

  describe '#hashtags' do
    context 'when entities are set' do
      let(:hashtags_array) do
        [{
          text: 'twitter',
          indices: [10, 33],
        }]
      end
      let(:subject) do
        Twitter::Tweet.new(id: 28_669_546_014, entities: {hashtags: hashtags_array})
      end
      it 'returns an array of Entity::Hashtag' do
        hashtags = subject.hashtags
        expect(hashtags).to be_an Array
        expect(hashtags.first).to be_a Twitter::Entity::Hashtag
        expect(hashtags.first.indices).to eq([10, 33])
        expect(hashtags.first.text).to eq('twitter')
      end
    end
    context 'when entities are set, but empty' do
      subject { Twitter::Tweet.new(id: 28_669_546_014, entities: {hashtags: []}) }
      it 'is empty' do
        expect(subject.hashtags).to be_empty
      end
      it 'does not warn' do
        subject.hashtags
        expect($stderr.string).to be_empty
      end
    end
    context 'when entities are not set' do
      subject { Twitter::Tweet.new(id: 28_669_546_014) }
      it 'is empty' do
        expect(subject.hashtags).to be_empty
      end
    end
  end

  describe '#hashtags?' do
    it 'returns true when the tweet includes hashtags entities' do
      entities = {hashtags: [{text: 'twitter', indices: [10, 33]}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: entities)
      expect(tweet.hashtags?).to be true
    end
    it 'returns false when no entities are present' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.hashtags?).to be false
    end
  end

  describe '#media' do
    it 'returns media' do
      media = Twitter::Tweet.new(id: 28_669_546_014, entities: {media: [{id: 1, type: 'photo'}]}).media
      expect(media).to be_an Array
      expect(media.first).to be_a Twitter::Media::Photo
    end
    it 'is empty when not set' do
      media = Twitter::Tweet.new(id: 28_669_546_014).media
      expect(media).to be_empty
    end
  end

  describe '#media?' do
    it 'returns true when the tweet includes media entities' do
      entities = {media: [{id: '1', type: 'photo'}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: entities)
      expect(tweet.media?).to be true
    end
    it 'returns false when no entities are present' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.media?).to be false
    end
  end

  describe '#metadata' do
    it 'returns a Twitter::Metadata when metadata is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, metadata: {result_type: 'recent'})
      expect(tweet.metadata).to be_a Twitter::Metadata
    end
    it 'returns nil when metadata is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.metadata).to be_nil
    end
  end

  describe '#metadata?' do
    it 'returns true when metadata is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, metadata: {result_type: 'recent'})
      expect(tweet.metadata?).to be true
    end
    it 'returns false when metadata is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.metadata?).to be false
    end
  end

  describe '#place' do
    it 'returns a Twitter::Place when place is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, place: {id: '247f43d441defc03'})
      expect(tweet.place).to be_a Twitter::Place
    end
    it 'returns nil when place is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.place).to be_nil
    end
  end

  describe '#place?' do
    it 'returns true when place is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, place: {id: '247f43d441defc03'})
      expect(tweet.place?).to be true
    end
    it 'returns false when place is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.place?).to be false
    end
  end

  describe '#reply?' do
    it 'returns true when there is an in-reply-to user' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, in_reply_to_user_id: 7_505_382)
      expect(tweet.reply?).to be true
    end
    it 'returns false when in_reply_to_user_id is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.reply?).to be false
    end
  end

  describe '#retweet?' do
    it 'returns true when there is a retweeted status' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, retweeted_status: {id: 540_897_316_908_331_009, text: 'BOOSH'})
      expect(tweet.retweet?).to be true
    end
    it 'returns false when retweeted_status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.retweet?).to be false
    end
  end

  describe '#retweeted_status' do
    it 'returns a Tweet when retweeted_status is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, retweeted_status: {id: 540_897_316_908_331_009, text: 'BOOSH'})
      expect(tweet.retweeted_tweet).to be_a Twitter::Tweet
      expect(tweet.retweeted_tweet.text).to eq('BOOSH')
    end
    it 'returns nil when retweeted_status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.retweeted_tweet).to be_nil
    end
  end

  describe '#retweeted_status?' do
    it 'returns true when retweeted_status is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, retweeted_status: {id: 540_897_316_908_331_009, text: 'BOOSH'})
      expect(tweet.retweeted_status?).to be true
    end
    it 'returns false when retweeted_status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.retweeted_status?).to be false
    end
  end

  describe '#quote?' do
    it 'returns true when there is a quoted status' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, quoted_status: {id: 540_897_316_908_331_009, text: 'BOOSH'})
      expect(tweet.quote?).to be true
    end
    it 'returns false when quoted_status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.quote?).to be false
    end
  end

  describe '#quoted_status' do
    it 'returns a Tweet when quoted_status is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, quoted_status: {id: 540_897_316_908_331_009, text: 'BOOSH'})
      expect(tweet.quoted_tweet).to be_a Twitter::Tweet
      expect(tweet.quoted_tweet.text).to eq('BOOSH')
    end
    it 'returns nil when quoted_status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.quoted_tweet).to be_nil
    end
  end

  describe '#quoted_status?' do
    it 'returns true when quoted_status is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, quoted_status: {id: 540_897_316_908_331_009, text: 'BOOSH'})
      expect(tweet.quoted_status?).to be true
    end
    it 'returns false when quoted_status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.quoted_status?).to be false
    end
  end

  describe '#symbols' do
    it 'returns an array of Entity::Symbol when symbols are set' do
      symbols_array = [
        {text: 'PEP', indices: [114, 118]},
        {text: 'COKE', indices: [128, 133]},
      ]
      symbols = Twitter::Tweet.new(id: 28_669_546_014, entities: {symbols: symbols_array}).symbols
      expect(symbols).to be_an Array
      expect(symbols.size).to eq(2)
      expect(symbols.first).to be_a Twitter::Entity::Symbol
      expect(symbols.first.indices).to eq([114, 118])
      expect(symbols.first.text).to eq('PEP')
    end
    it 'is empty when not set' do
      symbols = Twitter::Tweet.new(id: 28_669_546_014).symbols
      expect(symbols).to be_empty
    end
  end

  describe '#symbols?' do
    it 'returns true when the tweet includes symbols entities' do
      entities = {symbols: [{text: 'PEP'}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: entities)
      expect(tweet.symbols?).to be true
    end
    it 'returns false when no entities are present' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.symbols?).to be false
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
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: urls_array})
      expect(tweet.uris).to be_an Array
      expect(tweet.uris.first).to be_a Twitter::Entity::URI
      expect(tweet.uris.first.indices).to eq([10, 33])
      expect(tweet.uris.first.display_uri).to be_a String
      expect(tweet.uris.first.display_uri).to eq('example.com/expanded...')
    end
    it 'is empty when not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.uris).to be_empty
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
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: urls_array})
      uri = tweet.uris.first
      expect { uri.url }.not_to raise_error
      expect { uri.expanded_url }.not_to raise_error
      expect { uri.display_url }.not_to raise_error
    end
  end

  describe '#uri' do
    it 'returns the URI to the tweet' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, user: {id: 7_505_382, screen_name: 'sferik'})
      expect(tweet.uri).to be_an Addressable::URI
      expect(tweet.uri.to_s).to eq('https://twitter.com/sferik/status/28669546014')
    end
  end

  describe '#uris?' do
    it 'returns true when the tweet includes urls entities' do
      entities = {urls: [{url: 'https://t.co/L2xIBazMPf'}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: entities)
      expect(tweet.uris?).to be true
    end
    it 'returns false when no entities are present' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.uris?).to be false
    end
  end

  describe '#user' do
    it 'returns a User when user is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, user: {id: 7_505_382})
      expect(tweet.user).to be_a Twitter::User
    end
    it 'returns nil when user is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.user).to be_nil
    end
    it 'has a status is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: 'Tweet text.', user: {id: 7_505_382})
      expect(tweet.user.status).to be_a Twitter::Tweet
      expect(tweet.user.status.id).to eq 28_669_546_014
    end
  end

  describe '#user?' do
    it 'returns true when status is set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, user: {id: 7_505_382})
      expect(tweet.user?).to be true
    end
    it 'returns false when status is not set' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.user?).to be false
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
      user_mentions = Twitter::Tweet.new(id: 28_669_546_014, entities: {user_mentions: user_mentions_array}).user_mentions
      expect(user_mentions).to be_an Array
      expect(user_mentions.first).to be_a Twitter::Entity::UserMention
      expect(user_mentions.first.indices).to eq([0, 6])
      expect(user_mentions.first.id).to eq(7_505_382)
    end
    it 'is empty when not set' do
      user_mentions = Twitter::Tweet.new(id: 28_669_546_014).user_mentions
      expect(user_mentions).to be_empty
    end
  end

  describe '#user_mentions?' do
    it 'returns true when the tweet includes user_mention entities' do
      entities = {user_mentions: [{screen_name: 'sferik'}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: entities)
      expect(tweet.user_mentions?).to be true
    end
    it 'returns false when no entities are present' do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)
      expect(tweet.user_mentions?).to be false
    end
  end
end
