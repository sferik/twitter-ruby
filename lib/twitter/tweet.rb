require 'twitter/creatable'

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

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Hashtag>]
    def hashtags
      memoize(:hashtags) do
        entities(Twitter::Entity::Hashtag, :hashtags)
      end
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Media>]
    def media
      memoize(:media) do
        entities(Twitter::MediaFactory, :media)
      end
    end

    # @return [Boolean]
    def reply?
      !!@attrs[:in_reply_to_status_id]
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Symbol>]
    def symbols
      memoize(:symbols) do
        entities(Twitter::Entity::Symbol, :symbols)
      end
    end

    # @return [String] The URL to the tweet.
    def uri
      @uri ||= ::URI.parse("https://twitter.com/#{user.screen_name}/status/#{id}")
    end
    alias url uri

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::URI>]
    def uris
      memoize(:uris) do
        entities(Twitter::Entity::URI, :urls)
      end
    end
    alias urls uris

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::UserMention>]
    def user_mentions
      memoize(:user_mentions) do
        entities(Twitter::Entity::UserMention, :user_mentions)
      end
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
