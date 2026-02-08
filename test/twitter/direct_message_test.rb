require "test_helper"

describe Twitter::DirectMessage do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      direct_message = Twitter::DirectMessage.new(id: 1, text: "foo")
      other = Twitter::DirectMessage.new(id: 1, text: "bar")

      assert_equal(direct_message, other)
    end

    it "returns false when objects IDs are different" do
      direct_message = Twitter::DirectMessage.new(id: 1)
      other = Twitter::DirectMessage.new(id: 2)

      refute_equal(direct_message, other)
    end

    it "returns false when classes are different" do
      direct_message = Twitter::DirectMessage.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(direct_message, other)
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_kind_of(Time, direct_message.created_at)
      assert_predicate(direct_message.created_at, :utc?)
    end

    it "returns nil when created_at is not set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)

      assert_nil(direct_message.created_at)
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_predicate(direct_message, :created?)
    end

    it "returns false when created_at is not set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)

      refute_predicate(direct_message, :created?)
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
      tweet = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: urls_array})

      assert_predicate(tweet, :entities?)
    end

    it "returns false if there are blank lists of entities set" do
      tweet = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: []})

      refute_predicate(tweet, :entities?)
    end

    it "returns false if there are no entities set" do
      tweet = Twitter::DirectMessage.new(id: 1_825_786_345)

      refute_predicate(tweet, :entities?)
    end
  end

  describe "#recipient" do
    it "returns a User when recipient is set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, recipient: {id: 7_505_382})

      assert_kind_of(Twitter::User, direct_message.recipient)
    end

    it "returns nil when recipient is not set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)

      assert_nil(direct_message.recipient)
    end
  end

  describe "#recipient?" do
    it "returns true when recipient is set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, recipient: {id: 7_505_382})

      assert_predicate(direct_message, :recipient?)
    end

    it "returns false when recipient is not set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)

      refute_predicate(direct_message, :recipient?)
    end
  end

  describe "#sender" do
    it "returns a User when sender is set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, sender: {id: 7_505_382})

      assert_kind_of(Twitter::User, direct_message.sender)
    end

    it "returns nil when sender is not set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)

      assert_nil(direct_message.sender)
    end
  end

  describe "#sender?" do
    it "returns true when sender is set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, sender: {id: 7_505_382})

      assert_predicate(direct_message, :sender?)
    end

    it "returns false when sender is not set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)

      refute_predicate(direct_message, :sender?)
    end
  end

  describe "#hashtags" do
    it "returns an array of Entity::Hashtag when entities are set" do
      hashtags_array = [
        {
          text: "twitter",
          indices: [10, 33]
        }
      ]
      hashtags = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {hashtags: hashtags_array}).hashtags

      assert_kind_of(Array, hashtags)
      assert_kind_of(Twitter::Entity::Hashtag, hashtags.first)
      assert_equal([10, 33], hashtags.first.indices)
      assert_equal("twitter", hashtags.first.text)
    end

    it "is empty when not set" do
      hashtags = Twitter::DirectMessage.new(id: 1_825_786_345).hashtags

      assert_empty(hashtags)
    end
  end

  describe "#media" do
    it "returns media" do
      media = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {media: [{id: 1, type: "photo"}]}).media

      assert_kind_of(Array, media)
      assert_kind_of(Twitter::Media::Photo, media.first)
    end

    it "is empty when not set" do
      media = Twitter::DirectMessage.new(id: 1_825_786_345).media

      assert_empty(media)
    end
  end

  describe "#symbols" do
    it "returns an array of Entity::Symbol when symbols are set" do
      symbols_array = [
        {text: "PEP", indices: [114, 118]},
        {text: "COKE", indices: [128, 133]}
      ]
      symbols = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {symbols: symbols_array}).symbols

      assert_kind_of(Array, symbols)
      assert_equal(2, symbols.size)
      assert_kind_of(Twitter::Entity::Symbol, symbols.first)
      assert_equal([114, 118], symbols.first.indices)
      assert_equal("PEP", symbols.first.text)
    end

    it "is empty when not set" do
      symbols = Twitter::DirectMessage.new(id: 1_825_786_345).symbols

      assert_empty(symbols)
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
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: urls_array})

      assert_kind_of(Array, direct_message.uris)
      assert_kind_of(Twitter::Entity::URI, direct_message.uris.first)
      assert_equal([10, 33], direct_message.uris.first.indices)
      assert_kind_of(String, direct_message.uris.first.display_uri)
      assert_equal("example.com/expanded...", direct_message.uris.first.display_uri)
    end

    it "is empty when not set" do
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345)

      assert_empty(direct_message.uris)
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
      direct_message = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {urls: urls_array})
      uri = direct_message.uris.first
      assert_nothing_raised { uri.url }
      assert_nothing_raised { uri.expanded_url }
      assert_nothing_raised { uri.display_url }
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
      user_mentions = Twitter::DirectMessage.new(id: 1_825_786_345, entities: {user_mentions: user_mentions_array}).user_mentions

      assert_kind_of(Array, user_mentions)
      assert_kind_of(Twitter::Entity::UserMention, user_mentions.first)
      assert_equal([0, 6], user_mentions.first.indices)
      assert_equal(7_505_382, user_mentions.first.id)
    end

    it "is empty when not set" do
      user_mentions = Twitter::DirectMessage.new(id: 1_825_786_345).user_mentions

      assert_empty(user_mentions)
    end
  end
end
