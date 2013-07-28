require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class Tweet < Twitter::Identity
    include Twitter::Creatable
    attr_reader :favorite_count, :favorited, :in_reply_to_screen_name,
      :in_reply_to_attrs_id, :in_reply_to_status_id, :in_reply_to_user_id,
      :lang, :retweet_count, :retweeted, :source, :text, :truncated
    alias favorites_count favorite_count
    alias favourite_count favorite_count
    alias favourites_count favorite_count
    alias favoriters_count favorite_count
    alias favouriters_count favorite_count
    alias favourited favorited
    alias favourited? favorited?
    alias in_reply_to_tweet_id in_reply_to_status_id
    alias retweeters_count retweet_count

    # @return [Boolean]
    def entities?
      !@attrs[:entities].nil?
    end

    def filter_level
      @attrs[:filter_level] || "none"
    end

    # @return [String]
    # @note May be > 140 characters.
    def full_text
      if retweeted_status?
        prefix = text[/\A(RT @[a-z0-9_]{1,20}: )/i, 1]
        [prefix, retweeted_status.text].compact.join
      else
        text
      end
    end

    # @return [Twitter::Geo]
    def geo
      new_or_null_object(Twitter::GeoFactory, :geo)
    end

    # @return [Boolean]
    def geo?
      !geo.nil?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Hashtag>]
    def hashtags
      @hashtags ||= entities(Twitter::Entity::Hashtag, :hashtags)
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Media>]
    def media
      @media ||= entities(Twitter::MediaFactory, :media)
    end

    # @return [Twitter::Metadata, Twitter::NullObject]
    def metadata
      new_or_null_object(Twitter::Metadata, :metadata)
    end

    # @return [Boolean]
    def metadata?
      !metadata.nil?
    end

    # @return [Twitter::Place, Twitter::NullObject]
    def place
      new_or_null_object(Twitter::Place, :place)
    end

    # @return [Boolean]
    def place?
      !place.nil?
    end

    # @return [Boolean]
    def reply?
      !in_reply_to_status_id.nil?
    end

    # If this Tweet is a retweet, the original Tweet is available here.
    #
    # @return [Twitter::Tweet]
    def retweeted_status
      new_or_null_object(self.class, :retweeted_status)
    end
    alias retweet retweeted_status
    alias retweeted_tweet retweeted_status

    # @return [Boolean]
    def retweeted_status?
      !retweeted_status.nil?
    end
    alias retweet? retweeted_status?
    alias retweeted? retweeted_status?
    alias retweeted_tweet? retweeted_status?

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Symbol>]
    def symbols
      @symbols ||= entities(Twitter::Entity::Symbol, :symbols)
    end

    # @return [String] The URL to the tweet.
    def url(protocol="https")
      "#{protocol}://twitter.com/#{user.screen_name}/status/#{id}"
    end
    alias uri url

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Url>]
    def urls
      @urls ||= entities(Twitter::Entity::Url, :urls)
    end

    # @return [Twitter::User]
    def user
      new_without_self(Twitter::User, :user, :status)
    end

    def user?
      !user.nil?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::UserMention>]
    def user_mentions
      @user_mentions ||= entities(Twitter::Entity::UserMention, :user_mentions)
    end

  private

    # @param klass [Class]
    # @param key [Symbol]
    def entities(klass, key)
      if entities?
        Array(@attrs[:entities][key.to_sym]).map do |entity|
          klass.new(entity)
        end
      else
        warn "#{Kernel.caller.first}: To get #{key.to_s.tr('_', ' ')}, you must pass `:include_entities => true` when requesting the #{self.class.name}."
        []
      end
    end

  end

  Status = Tweet
end
