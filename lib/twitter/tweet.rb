require "twitter/creatable"
require "twitter/entities"
require "twitter/identity"

module Twitter
  # Represents a Twitter tweet
  class Tweet < Identity
    include Creatable
    include Entities

    # The filter level of the tweet
    #
    # @api public
    # @example
    #   tweet.filter_level
    # @return [String]

    # The screen name of the user being replied to
    #
    # @api public
    # @example
    #   tweet.in_reply_to_screen_name
    # @return [String]

    # The language of the tweet
    #
    # @api public
    # @example
    #   tweet.lang
    # @return [String]

    # The source of the tweet
    #
    # @api public
    # @example
    #   tweet.source
    # @return [String]

    # The text of the tweet
    #
    # @api public
    # @example
    #   tweet.text
    # @return [String]
    attr_reader :filter_level, :in_reply_to_screen_name, :lang, :source, :text

    # The number of times this tweet has been favorited
    #
    # @api public
    # @example
    #   tweet.favorite_count
    # @return [Integer]

    # The ID of the status being replied to
    #
    # @api public
    # @example
    #   tweet.in_reply_to_status_id
    # @return [Integer]

    # The ID of the user being replied to
    #
    # @api public
    # @example
    #   tweet.in_reply_to_user_id
    # @return [Integer]

    # The number of times this tweet has been quoted
    #
    # @api public
    # @example
    #   tweet.quote_count
    # @return [Integer]

    # The number of replies to this tweet
    #
    # @api public
    # @example
    #   tweet.reply_count
    # @return [Integer]

    # The number of times this tweet has been retweeted
    #
    # @api public
    # @example
    #   tweet.retweet_count
    # @return [Integer]
    attr_reader :favorite_count, :in_reply_to_status_id, :in_reply_to_user_id,
                :quote_count, :reply_count, :retweet_count

    # @!method in_reply_to_tweet_id
    #   The ID of the tweet being replied to
    #   @api public
    #   @example
    #     tweet.in_reply_to_tweet_id
    #   @return [Integer]
    alias in_reply_to_tweet_id in_reply_to_status_id

    # Returns true if this is a reply
    #
    # @!method reply?
    # @api public
    # @example
    #   tweet.reply?
    # @return [Boolean]
    alias reply? in_reply_to_user_id?
    object_attr_reader :GeoFactory, :geo
    object_attr_reader :Metadata, :metadata
    object_attr_reader :Place, :place
    object_attr_reader :Tweet, :retweeted_status
    object_attr_reader :Tweet, :quoted_status
    object_attr_reader :Tweet, :current_user_retweet

    # Returns the retweeted tweet
    #
    # @!method retweeted_tweet
    # @api public
    # @example
    #   tweet.retweeted_tweet
    # @return [Twitter::Tweet]
    alias retweeted_tweet retweeted_status

    # Returns true if this is a retweet
    #
    # @!method retweet?
    # @api public
    # @example
    #   tweet.retweet?
    # @return [Boolean]
    alias retweet? retweeted_status?

    # Returns true if this has a retweeted tweet
    #
    # @!method retweeted_tweet?
    # @api public
    # @example
    #   tweet.retweeted_tweet?
    # @return [Boolean]
    alias retweeted_tweet? retweeted_status?

    # Returns the quoted tweet
    #
    # @!method quoted_tweet
    # @api public
    # @example
    #   tweet.quoted_tweet
    # @return [Twitter::Tweet]
    alias quoted_tweet quoted_status

    # Returns true if this is a quote tweet
    #
    # @!method quote?
    # @api public
    # @example
    #   tweet.quote?
    # @return [Boolean]
    alias quote? quoted_status?

    # Returns true if this has a quoted tweet
    #
    # @!method quoted_tweet?
    # @api public
    # @example
    #   tweet.quoted_tweet?
    # @return [Boolean]
    alias quoted_tweet? quoted_status?
    object_attr_reader :User, :user, :status
    predicate_attr_reader :favorited, :possibly_sensitive, :retweeted,
                          :truncated

    # Initializes a new Tweet object
    #
    # @api public
    # @example
    #   Twitter::Tweet.new(id: 123, text: "Hello")
    # @param attrs [Hash] The attributes hash containing at least :id
    # @return [Twitter::Tweet]
    def initialize(attrs)
      attrs[:text] ||= attrs[:full_text]
      super
    end

    # Returns the full text of the tweet
    #
    # @api public
    # @note May be > 280 characters
    # @example
    #   tweet.full_text
    # @return [String]
    def full_text
      if retweet?
        prefix = text[/\A(RT @[a-z0-9_]{1,20}: )/i, 1]
        [prefix, retweeted_status.text].compact.join
      else
        text
      end
    end
    memoize :full_text

    # Returns the URI to the tweet
    #
    # @api public
    # @example
    #   tweet.uri
    # @return [Addressable::URI]
    def uri
      Addressable::URI.parse("https://twitter.com/#{user.screen_name}/status/#{id}") if user?
    end
    memoize :uri

    # @!method url
    #   Returns the URL to the tweet
    #   @api public
    #   @example
    #     tweet.url
    #   @return [Addressable::URI]
    alias url uri
  end
end
