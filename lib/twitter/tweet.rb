require 'twitter/creatable'
require 'twitter/entities'
require 'twitter/identity'

module Twitter
  class Tweet < Twitter::Identity
    include Twitter::Creatable
    include Twitter::Entities
    attr_reader :favorite_count, :favorited, :filter_level,
                :in_reply_to_screen_name, :in_reply_to_attrs_id,
                :in_reply_to_status_id, :in_reply_to_user_id, :lang,
                :retweet_count, :retweeted, :source, :text, :truncated
    deprecate_alias :favorites_count, :favorite_count
    deprecate_alias :favoriters_count, :favorite_count
    alias_method :in_reply_to_tweet_id, :in_reply_to_status_id
    alias_method :reply?, :in_reply_to_user_id?
    deprecate_alias :retweeters_count, :retweet_count
    object_attr_reader :GeoFactory, :geo
    object_attr_reader :Metadata, :metadata
    object_attr_reader :Place, :place
    object_attr_reader :Tweet, :retweeted_status
    alias_method :retweet, :retweeted_status
    alias_method :retweeted_tweet, :retweeted_status
    alias_method :retweet?, :retweeted_status?
    alias_method :retweeted_tweet?, :retweeted_status?
    object_attr_reader :User, :user, :status

    # @note May be > 140 characters.
    # @return [String]
    def attributes
        @attrs
    end

    def attr
        @attrs
    end
    
    def favorite_count
        @attrs.favorite_count
    end

    def favorited
        @attrs.favorited
    end

    def in_reply_to_screen_name
        @attrs.in_reply_to_screen_name
    end

    def in_reply_to_attrs_id
        @attrs.in_reply_to_attrs_id
    end

    def in_reply_to_status_id
        @attrs.in_reply_to_status_id
    end    

    def in_reply_to_user_id
        @attr.in_reply_to_user_id
    end

    def retweet_count
        @attrs.retweet_count
    end

    def retweeted
        @attrs.retweeted
    end

    def source
        @attrs.source
    end

    def text
        @attrs.text
    end

    def truncated
        @attrs.truncated
    end

    def full_text
      if retweet?
        prefix = text[/\A(RT @[a-z0-9_]{1,20}: )/i, 1]
        [prefix, retweeted_status.text].compact.join
      else
        text
      end
    end
    memoize :full_text

    # @return [String] The URL to the tweet.
    def uri
      Addressable::URI.parse("https://twitter.com/#{user.screen_name}/status/#{id}") unless user.nil?
    end
    memoize :uri
    alias_method :url, :uri
  end
  Status = Tweet # rubocop:disable ConstantName
end
