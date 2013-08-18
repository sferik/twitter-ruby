require 'helper'

describe Twitter::Tweet do

  before do
    @old_stderr = $stderr
    $stderr = StringIO.new
  end

  after do
    $stderr = @old_stderr
  end

  describe "#==" do
    it "returns true when objects IDs are the same" do
      tweet = Twitter::Tweet.new(:id => 1, :text => "foo")
      other = Twitter::Tweet.new(:id => 1, :text => "bar")
      expect(tweet == other).to be_true
    end
    it "returns false when objects IDs are different" do
      tweet = Twitter::Tweet.new(:id => 1)
      other = Twitter::Tweet.new(:id => 2)
      expect(tweet == other).to be_false
    end
    it "returns false when classes are different" do
      tweet = Twitter::Tweet.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      expect(tweet == other).to be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :created_at => "Mon Jul 16 12:59:01 +0000 2007")
      expect(tweet.created_at).to be_a Time
    end
    it "returns nil when not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.created_at).to be_nil
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :created_at => "Mon Jul 16 12:59:01 +0000 2007")
      expect(tweet.created?).to be_true
    end
    it "returns false when created_at is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.created?).to be_false
    end
  end

  describe "#entities?" do
    it "returns false if there are no entities set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.entities?).to be_false
    end

    it "returns true if there are entities set" do
      urls_array = [
        {
          :url => "http://example.com/t.co",
          :expanded_url => "http://example.com/expanded",
          :display_url => "example.com/expanded",
          :indices => [10, 33],
        }
      ]
      tweet = Twitter::Tweet.new(:id => 28669546014, :entities => {:urls => urls_array})
      expect(tweet.entities?).to be_true
    end
  end

  describe "#filter_level" do
    it "returns the filter level when filter_level is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :filter_level => "high")
      expect(tweet.filter_level).to be_a String
      expect(tweet.filter_level).to eq("high")
    end
    it "returns \"none\" when not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.filter_level).to eq("none")
    end
  end

  describe "#full_text" do
    it "returns the text of a Tweet" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :text => "BOOSH")
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq("BOOSH")
    end
    it "returns the text of a Tweet without a user" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :text => "BOOSH", :retweeted_status => {:id => 28561922517, :text => "BOOSH"})
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq("BOOSH")
    end
    it "returns the full text of a retweeted Tweet" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :text => "RT @sferik: BOOSH", :retweeted_status => {:id => 25938088801, :text => "BOOSH"})
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq("RT @sferik: BOOSH")
    end
    it "returns nil when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.full_text).to be_nil
    end
  end

  describe "#geo" do
    it "returns a Twitter::Geo::Point when geo is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :geo => {:id => 1, :type => "Point"})
      expect(tweet.geo).to be_a Twitter::Geo::Point
    end
    it "returns nil when geo is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.geo).to be_nil
    end
  end

  describe "#geo?" do
    it "returns true when geo is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :geo => {:id => 1, :type => "Point"})
      expect(tweet.geo?).to be_true
    end
    it "returns false when geo is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.geo?).to be_false
    end
  end

  describe "#hashtags" do
    it "returns an array of Entity::Hashtag when entities are set" do
      hashtags_array = [
        {
          :text => "twitter",
          :indices => [10, 33],
        }
      ]
      hashtags = Twitter::Tweet.new(:id => 28669546014, :entities => {:hashtags => hashtags_array}).hashtags
      expect(hashtags).to be_an Array
      expect(hashtags.first).to be_a Twitter::Entity::Hashtag
      expect(hashtags.first.indices).to eq([10, 33])
      expect(hashtags.first.text).to eq("twitter")
    end
    it "is empty when not set" do
      hashtags = Twitter::Tweet.new(:id => 28669546014).hashtags
      expect(hashtags).to be_empty
    end
    it "warns when not set" do
      Twitter::Tweet.new(:id => 28669546014).hashtags
      expect($stderr.string).to match(/To get hashtags, you must pass `:include_entities => true` when requesting the Twitter::Tweet\./)
    end
  end

  describe "#media" do
    it "returns media" do
      media = Twitter::Tweet.new(:id => 28669546014, :entities => {:media => [{:id => 1, :type => "photo"}]}).media
      expect(media).to be_an Array
      expect(media.first).to be_a Twitter::Media::Photo
    end
    it "is empty when not set" do
      media = Twitter::Tweet.new(:id => 28669546014).media
      expect(media).to be_empty
    end
    it "warns when not set" do
      Twitter::Tweet.new(:id => 28669546014).media
      expect($stderr.string).to match(/To get media, you must pass `:include_entities => true` when requesting the Twitter::Tweet\./)
    end
  end

  describe "#metadata" do
    it "returns a Twitter::Metadata when metadata is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :metadata => {})
      expect(tweet.metadata).to be_a Twitter::Metadata
    end
    it "returns nil when metadata is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.metadata).to be_nil
    end
  end

  describe "#metadata?" do
    it "returns true when metadata is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :metadata => {})
      expect(tweet.metadata?).to be_true
    end
    it "returns false when metadata is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.metadata?).to be_false
    end
  end

  describe "#place" do
    it "returns a Twitter::Place when place is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :place => {:id => "247f43d441defc03"})
      expect(tweet.place).to be_a Twitter::Place
    end
    it "returns nil when place is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.place).to be_nil
    end
  end

  describe "#place?" do
    it "returns true when place is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :place => {:id => "247f43d441defc03"})
      expect(tweet.place?).to be_true
    end
    it "returns false when place is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.place?).to be_false
    end
  end

  describe "#reply?" do
    it "returns true when there is an in-reply-to status" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :in_reply_to_status_id => 114749583439036416)
      expect(tweet.reply?).to be_true
    end
    it "returns false when in_reply_to_status_id is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.reply?).to be_false
    end
  end

  describe "#retweet?" do
    it "returns true when there is a retweeted status" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :retweeted_status => {:id => 25938088801, :text => "BOOSH"})
      expect(tweet.retweet?).to be_true
    end
    it "returns false when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.retweet?).to be_false
    end
  end

  describe "#retweeted_status" do
    it "returns a Tweet when retweeted_status is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :retweeted_status => {:id => 25938088801, :text => "BOOSH"})
      expect(tweet.retweeted_tweet).to be_a Twitter::Tweet
      expect(tweet.retweeted_tweet.text).to eq("BOOSH")
    end
    it "returns nil when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.retweeted_tweet).to be_nil
    end
  end

  describe "#retweeted_status?" do
    it "returns true when retweeted_status is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :retweeted_status => {:id => 25938088801, :text => "BOOSH"})
      expect(tweet.retweeted_status?).to be_true
    end
    it "returns false when retweeted_status is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.retweeted_status?).to be_false
    end
  end

  describe "#symbols" do
    it "returns an array of Entity::Symbol when symbols are set" do
      symbols_array = [
        { :text => "PEP", :indices => [114, 118] },
        { :text => "COKE", :indices => [128, 133] }
      ]
      symbols = Twitter::Tweet.new(:id => 28669546014, :entities => {:symbols => symbols_array}).symbols
      expect(symbols).to be_an Array
      expect(symbols.size).to eq(2)
      expect(symbols.first).to be_a Twitter::Entity::Symbol
      expect(symbols.first.indices).to eq([114, 118])
      expect(symbols.first.text).to eq("PEP")
    end
    it "is empty when not set" do
      symbols = Twitter::Tweet.new(:id => 28669546014).symbols
      expect(symbols).to be_empty
    end
    it "warns when not set" do
      Twitter::Tweet.new(:id => 28669546014).symbols
      expect($stderr.string).to match(/To get symbols, you must pass `:include_entities => true` when requesting the Twitter::Tweet\./)
    end
  end

  describe "#uris" do
    it "returns an array of Entity::URIs when entities are set" do
      urls_array = [
        {
          :url => "http://example.com/t.co",
          :expanded_url => "http://example.com/expanded",
          :display_url => "example.com/expanded",
          :indices => [10, 33],
        }
      ]
      tweet = Twitter::Tweet.new(:id => 28669546014, :entities => {:urls => urls_array})
      expect(tweet.uris).to be_an Array
      expect(tweet.uris.first).to be_a Twitter::Entity::URI
      expect(tweet.uris.first.indices).to eq([10, 33])
      expect(tweet.uris.first.display_uri).to be_a URI
      expect(tweet.uris.first.display_uri.to_s).to eq("example.com/expanded")
    end
    it "is empty when not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.uris).to be_empty
    end
    it "warns when not set" do
      Twitter::Tweet.new(:id => 28669546014).urls
      expect($stderr.string).to match(/To get urls, you must pass `:include_entities => true` when requesting the Twitter::Tweet\./)
    end
  end

  describe "#uri" do
    it "returns the URI to the tweet" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :user => {:id => 7505382, :screen_name => "sferik"})
      expect(tweet.uri).to be_a URI
      expect(tweet.uri.to_s).to eq("https://twitter.com/sferik/status/28669546014")
    end
  end

  describe "#user" do
    it "returns a User when user is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :user => {:id => 7505382})
      expect(tweet.user).to be_a Twitter::User
    end
    it "returns nil when user is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.user).to be_nil
    end
    it "has a status is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :text => "Tweet text.", :user => {:id => 7505382})
      expect(tweet.user.status).to be_a Twitter::Tweet
      expect(tweet.user.status.id).to eq 28669546014
    end
  end

  describe "#user?" do
    it "returns true when status is set" do
      tweet = Twitter::Tweet.new(:id => 28669546014, :user => {:id => 7505382})
      expect(tweet.user?).to be_true
    end
    it "returns false when status is not set" do
      tweet = Twitter::Tweet.new(:id => 28669546014)
      expect(tweet.user?).to be_false
    end
  end

  describe "#user_mentions" do
    it "returns an array of Entity::UserMention when entities are set" do
      user_mentions_array = [
        {
          :screen_name => "sferik",
          :name => "Erik Michaels-Ober",
          :id_str => "7505382",
          :indices => [0, 6],
          :id => 7505382,
        }
      ]
      user_mentions = Twitter::Tweet.new(:id => 28669546014, :entities => {:user_mentions => user_mentions_array}).user_mentions
      expect(user_mentions).to be_an Array
      expect(user_mentions.first).to be_a Twitter::Entity::UserMention
      expect(user_mentions.first.indices).to eq([0, 6])
      expect(user_mentions.first.id).to eq(7505382)
    end
    it "is empty when not set" do
      user_mentions = Twitter::Tweet.new(:id => 28669546014).user_mentions
      expect(user_mentions).to be_empty
    end
    it "warns when not set" do
      Twitter::Tweet.new(:id => 28669546014).user_mentions
      expect($stderr.string).to match(/To get user mentions, you must pass `:include_entities => true` when requesting the Twitter::Tweet\./)
    end
  end

end
