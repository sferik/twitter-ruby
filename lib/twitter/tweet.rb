require 'twitter/creatable'

module Twitter
  class Tweet < Twitter::Identity
    include Twitter::Creatable
    attr_reader :favorite_count, :favorited, :in_reply_to_screen_name,
      :in_reply_to_attrs_id, :in_reply_to_status_id, :in_reply_to_user_id,
      :lang, :retweet_count, :retweeted, :source, :text, :truncated
    alias favorites_count favorite_count
    alias favoriters_count favorite_count
    alias in_reply_to_tweet_id in_reply_to_status_id
    alias retweeters_count retweet_count
    object_attr_reader :GeoFactory, :geo
    object_attr_reader :Metadata, :metadata
    object_attr_reader :Place, :place
    object_attr_reader :Tweet, :retweeted_status
    alias retweet retweeted_status
    alias retweeted_tweet retweeted_status
    alias retweet? retweeted_status?
    alias retweeted_tweet? retweeted_status?
    object_attr_reader :User, :user, :status

    # @return [Boolean]
    def entities?
      !@attrs[:entities].nil? && @attrs[:entities].any?{|_, array| !array.empty?}
    end
    memoize :entities?

    def filter_level
      @attrs[:filter_level] || "none"
    end
    memoize :filter_level

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
    memoize :full_text

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Hashtag>]
    def hashtags
      entities(Entity::Hashtag, :hashtags)
    end
    memoize :hashtags

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Media>]
    def media
      entities(MediaFactory, :media)
    end
    memoize :media

    # @return [Boolean]
    def reply?
      !!@attrs[:in_reply_to_status_id]
    end
    memoize :reply?

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Symbol>]
    def symbols
      entities(Entity::Symbol, :symbols)
    end
    memoize :symbols

    # @return [String] The URL to the tweet.
    def uri
      URI.parse("https://twitter.com/#{user.screen_name}/status/#{id}")
    end
    memoize :uri
    alias url uri

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::URI>]
    def uris
      entities(Entity::URI, :urls)
    end
    memoize :uris
    alias urls uris

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::UserMention>]
    def user_mentions
      entities(Entity::UserMention, :user_mentions)
    end
    memoize :user_mentions

  private

    # @param klass [Class]
    # @param key [Symbol]
    def entities(klass, key)
      if entities?
        Array(@attrs[:entities][key.to_sym]).map do |entity|
          klass.new(entity)
        end
      else
        warn "#{Kernel.caller.first}: To get #{key.to_s.tr('_', ' ')}, you must pass `:include_entities => true` when requesting the #{self.class}."
        []
      end
    end

  end

  Status = Tweet
end
