require "test_helper"

describe Twitter::Tweet do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      tweet = Twitter::Tweet.new(id: 1, text: "foo")
      other = Twitter::Tweet.new(id: 1, text: "bar")

      assert_equal(tweet, other)
    end

    it "returns false when objects IDs are different" do
      tweet = Twitter::Tweet.new(id: 1)
      other = Twitter::Tweet.new(id: 2)

      refute_equal(tweet, other)
    end

    it "returns false when classes are different" do
      tweet = Twitter::Tweet.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(tweet, other)
    end
  end

  describe "#created_at" do
    it "returns a Time when set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_kind_of(Time, tweet.created_at)
      assert_predicate(tweet.created_at, :utc?)
    end

    it "returns nil when not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.created_at)
    end

    it "returns the same Time when created_at is already a Time object" do
      time = Time.now.utc
      tweet = Twitter::Tweet.new(id: 28_669_546_014, created_at: time)

      assert_kind_of(Time, tweet.created_at)
      assert_predicate(tweet.created_at, :utc?)
      assert_equal(time, tweet.created_at)
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_predicate(tweet, :created?)
    end

    it "returns false when created_at is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :created?)
    end
  end

  describe "#entities?" do
    it "returns true if there are entities set" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [10, 33]
        }
      ]
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: urls_array})

      assert_predicate(tweet, :entities?)
    end

    it "returns false if there are blank lists of entities set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: []})

      refute_predicate(tweet, :entities?)
    end

    it "returns false if there are no entities set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :entities?)
    end
  end

  describe "#filter_level" do
    it "returns the filter level when filter_level is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, filter_level: "high")

      assert_kind_of(String, tweet.filter_level)
      assert_equal("high", tweet.filter_level)
    end

    it "returns nil when not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.filter_level)
    end
  end

  describe "#initialize" do
    it "copies full_text to text when text is nil and full_text is present" do
      tweet = Twitter::Tweet.new(id: 1, full_text: "extended text")

      assert_equal("extended text", tweet.text)
    end

    it "does not copy full_text to text when text is already present" do
      tweet = Twitter::Tweet.new(id: 1, text: "original", full_text: "extended")

      assert_equal("original", tweet.text)
    end

    it "leaves text as nil when both text and full_text are nil" do
      tweet = Twitter::Tweet.new(id: 1, text: nil, full_text: nil)

      assert_nil(tweet.text)
    end

    it "handles missing text and full_text keys" do
      tweet = Twitter::Tweet.new(id: 1)

      assert_nil(tweet.text)
    end
  end

  describe "#full_text" do
    it "returns the text of a Tweet" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: "BOOSH")

      assert_kind_of(String, tweet.full_text)
      assert_equal("BOOSH", tweet.full_text)
    end

    it "returns the text of an extended Tweet" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: nil, full_text: "BOOSH")

      assert_kind_of(String, tweet.full_text)
      assert_equal("BOOSH", tweet.full_text)
    end

    it "returns the text of a Tweet without a user" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: "BOOSH", retweeted_status: {id: 28_561_922_517, text: "BOOSH"})

      assert_kind_of(String, tweet.full_text)
      assert_equal("BOOSH", tweet.full_text)
    end

    it "returns the full text of a retweeted Tweet" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: "RT @sferik: BOOSH", retweeted_status: {id: 540_897_316_908_331_009, text: "BOOSH"})

      assert_kind_of(String, tweet.full_text)
      assert_equal("RT @sferik: BOOSH", tweet.full_text)
    end

    it "returns nil when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.full_text)
    end
  end

  describe "#geo" do
    it "returns a Twitter::Geo::Point when geo is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, geo: {id: 1, type: "Point"})

      assert_kind_of(Twitter::Geo::Point, tweet.geo)
    end

    it "returns nil when geo is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.geo)
    end
  end

  describe "#geo?" do
    it "returns true when geo is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, geo: {id: 1, type: "Point"})

      assert_predicate(tweet, :geo?)
    end

    it "returns false when geo is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :geo?)
    end
  end

  describe "#hashtags" do
    describe "when entities are set" do
      let(:tweet) { Twitter::Tweet.new(id: 28_669_546_014, entities: {hashtags: hashtags_array}) }

      let(:hashtags_array) do
        [{
          text: "twitter",
          indices: [10, 33]
        }]
      end

      it "returns an array of Entity::Hashtag" do
        hashtags = tweet.hashtags

        assert_kind_of(Array, hashtags)
        assert_kind_of(Twitter::Entity::Hashtag, hashtags.first)
        assert_equal([10, 33], hashtags.first.indices)
        assert_equal("twitter", hashtags.first.text)
      end
    end

    describe "when entities are set, but empty" do
      let(:tweet) { Twitter::Tweet.new(id: 28_669_546_014, entities: {hashtags: []}) }

      it "is empty" do
        assert_empty(tweet.hashtags)
      end

      it "does not warn" do
        assert_output(nil, "") { tweet.hashtags }
      end
    end

    describe "when entities are not set" do
      let(:tweet) { Twitter::Tweet.new(id: 28_669_546_014) }

      it "is empty" do
        assert_empty(tweet.hashtags)
      end
    end
  end

  describe "#hashtags?" do
    it "returns true when the tweet includes hashtags entities" do
      entities = {hashtags: [{text: "twitter", indices: [10, 33]}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities:)

      assert_predicate(tweet, :hashtags?)
    end

    it "returns false when no entities are present" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :hashtags?)
    end
  end

  describe "#media" do
    it "returns media" do
      media = Twitter::Tweet.new(id: 28_669_546_014, entities: {media: [{id: 1, type: "photo"}]}).media

      assert_kind_of(Array, media)
      assert_kind_of(Twitter::Media::Photo, media.first)
    end

    it "is empty when not set" do
      media = Twitter::Tweet.new(id: 28_669_546_014).media

      assert_empty(media)
    end

    it "returns extended_entities media when present" do
      media = Twitter::Tweet.new(id: 28_669_546_014, extended_entities: {media: [{id: 1, type: "photo"}]}).media

      assert_kind_of(Array, media)
      assert_kind_of(Twitter::Media::Photo, media.first)
    end
  end

  describe "#media?" do
    it "returns true when the tweet includes media entities" do
      entities = {media: [{id: "1", type: "photo"}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities:)

      assert_predicate(tweet, :media?)
    end

    it "returns false when no entities are present" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :media?)
    end
  end

  describe "#metadata" do
    it "returns a Twitter::Metadata when metadata is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, metadata: {result_type: "recent"})

      assert_kind_of(Twitter::Metadata, tweet.metadata)
    end

    it "returns nil when metadata is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.metadata)
    end
  end

  describe "#metadata?" do
    it "returns true when metadata is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, metadata: {result_type: "recent"})

      assert_predicate(tweet, :metadata?)
    end

    it "returns false when metadata is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :metadata?)
    end
  end

  describe "#place" do
    it "returns a Twitter::Place when place is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, place: {id: "247f43d441defc03"})

      assert_kind_of(Twitter::Place, tweet.place)
    end

    it "returns nil when place is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.place)
    end
  end

  describe "#place?" do
    it "returns true when place is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, place: {id: "247f43d441defc03"})

      assert_predicate(tweet, :place?)
    end

    it "returns false when place is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :place?)
    end
  end

  describe "#reply?" do
    it "returns true when there is an in-reply-to user" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, in_reply_to_user_id: 7_505_382)

      assert_predicate(tweet, :reply?)
    end

    it "returns false when in_reply_to_user_id is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :reply?)
    end
  end

  describe "#retweet?" do
    it "returns true when there is a retweeted status" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, retweeted_status: {id: 540_897_316_908_331_009, text: "BOOSH"})

      assert_predicate(tweet, :retweet?)
    end

    it "returns false when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :retweet?)
    end
  end

  describe "#retweeted_status" do
    it "returns a Tweet when retweeted_status is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, retweeted_status: {id: 540_897_316_908_331_009, text: "BOOSH"})

      assert_kind_of(Twitter::Tweet, tweet.retweeted_tweet)
      assert_equal("BOOSH", tweet.retweeted_tweet.text)
    end

    it "returns nil when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.retweeted_tweet)
    end
  end

  describe "#retweeted_status?" do
    it "returns true when retweeted_status is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, retweeted_status: {id: 540_897_316_908_331_009, text: "BOOSH"})

      assert_predicate(tweet, :retweeted_status?)
    end

    it "returns false when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :retweeted_status?)
    end
  end

  describe "#quote?" do
    it "returns true when there is a quoted status" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, quoted_status: {id: 540_897_316_908_331_009, text: "BOOSH"})

      assert_predicate(tweet, :quote?)
    end

    it "returns false when quoted_status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :quote?)
    end
  end

  describe "#quoted_status" do
    it "returns a Tweet when quoted_status is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, quoted_status: {id: 540_897_316_908_331_009, text: "BOOSH"})

      assert_kind_of(Twitter::Tweet, tweet.quoted_tweet)
      assert_equal("BOOSH", tweet.quoted_tweet.text)
    end

    it "returns nil when quoted_status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.quoted_tweet)
    end
  end

  describe "#quoted_status?" do
    it "returns true when quoted_status is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, quoted_status: {id: 540_897_316_908_331_009, text: "BOOSH"})

      assert_predicate(tweet, :quoted_status?)
    end

    it "returns false when quoted_status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :quoted_status?)
    end
  end

  describe "#symbols" do
    it "returns an array of Entity::Symbol when symbols are set" do
      symbols_array = [
        {text: "PEP", indices: [114, 118]},
        {text: "COKE", indices: [128, 133]}
      ]
      symbols = Twitter::Tweet.new(id: 28_669_546_014, entities: {symbols: symbols_array}).symbols

      assert_kind_of(Array, symbols)
      assert_equal(2, symbols.size)
      assert_kind_of(Twitter::Entity::Symbol, symbols.first)
      assert_equal([114, 118], symbols.first.indices)
      assert_equal("PEP", symbols.first.text)
    end

    it "is empty when not set" do
      symbols = Twitter::Tweet.new(id: 28_669_546_014).symbols

      assert_empty(symbols)
    end
  end

  describe "#symbols?" do
    it "returns true when the tweet includes symbols entities" do
      entities = {symbols: [{text: "PEP"}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities:)

      assert_predicate(tweet, :symbols?)
    end

    it "returns false when no entities are present" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :symbols?)
    end
  end

  describe "#uris" do
    it "returns an array of Entity::URIs when entities are set" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [10, 33]
        }
      ]
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: urls_array})

      assert_kind_of(Array, tweet.uris)
      assert_kind_of(Twitter::Entity::URI, tweet.uris.first)
      assert_equal([10, 33], tweet.uris.first.indices)
      assert_kind_of(String, tweet.uris.first.display_uri)
      assert_equal("example.com/expanded...", tweet.uris.first.display_uri)
    end

    it "is empty when not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_empty(tweet.uris)
    end

    it "can handle strange urls" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://with_underscore.example.com/expanded",
          display_url: "with_underscore.example.com/expanded...",
          indices: [10, 33]
        }
      ]
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities: {urls: urls_array})
      uri = tweet.uris.first
      assert_nothing_raised { uri.url }
      assert_nothing_raised { uri.expanded_url }
      assert_nothing_raised { uri.display_url }
    end
  end

  describe "#uri" do
    it "returns the URI to the tweet" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, user: {id: 7_505_382, screen_name: "sferik"})

      assert_kind_of(Addressable::URI, tweet.uri)
      assert_equal("https://twitter.com/sferik/status/28669546014", tweet.uri.to_s)
    end

    it "returns nil when user is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.uri)
    end
  end

  describe "#uris?" do
    it "returns true when the tweet includes urls entities" do
      entities = {urls: [{url: "https://t.co/L2xIBazMPf"}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities:)

      assert_predicate(tweet, :uris?)
    end

    it "returns false when no entities are present" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :uris?)
    end
  end

  describe "#user" do
    it "returns a User when user is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, user: {id: 7_505_382})

      assert_kind_of(Twitter::User, tweet.user)
    end

    it "returns nil when user is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      assert_nil(tweet.user)
    end

    it "has a status is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, text: "Tweet text.", user: {id: 7_505_382})

      assert_kind_of(Twitter::Tweet, tweet.user.status)
      assert_equal(28_669_546_014, tweet.user.status.id)
    end
  end

  describe "#user?" do
    it "returns true when status is set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014, user: {id: 7_505_382})

      assert_predicate(tweet, :user?)
    end

    it "returns false when status is not set" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :user?)
    end
  end

  describe "#user_mentions" do
    it "returns an array of Entity::UserMention when entities are set" do
      user_mentions_array = [
        {
          screen_name: "sferik",
          name: "Erik Berlin",
          id_str: "7_505_382",
          indices: [0, 6],
          id: 7_505_382
        }
      ]
      user_mentions = Twitter::Tweet.new(id: 28_669_546_014, entities: {user_mentions: user_mentions_array}).user_mentions

      assert_kind_of(Array, user_mentions)
      assert_kind_of(Twitter::Entity::UserMention, user_mentions.first)
      assert_equal([0, 6], user_mentions.first.indices)
      assert_equal(7_505_382, user_mentions.first.id)
    end

    it "is empty when not set" do
      user_mentions = Twitter::Tweet.new(id: 28_669_546_014).user_mentions

      assert_empty(user_mentions)
    end
  end

  describe "#user_mentions?" do
    it "returns true when the tweet includes user_mention entities" do
      entities = {user_mentions: [{screen_name: "sferik"}]}
      tweet = Twitter::Tweet.new(id: 28_669_546_014, entities:)

      assert_predicate(tweet, :user_mentions?)
    end

    it "returns false when no entities are present" do
      tweet = Twitter::Tweet.new(id: 28_669_546_014)

      refute_predicate(tweet, :user_mentions?)
    end
  end

  describe "#entities (private)" do
    it "symbolizes key arguments passed as strings" do
      tweet = Twitter::Tweet.new(
        id: 28_669_546_014,
        entities: {
          urls: [
            {
              url: "https://t.co/example",
              expanded_url: "https://example.com",
              display_url: "example.com",
              indices: [0, 23]
            }
          ]
        }
      )

      uris = tweet.send(:entities, Twitter::Entity::URI, "urls", "entities")

      assert_kind_of(Array, uris)
      assert_kind_of(Twitter::Entity::URI, uris.first)
      assert_equal("https://example.com", uris.first.expanded_uri.to_s)
    end
  end
end
