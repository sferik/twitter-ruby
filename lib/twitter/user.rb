require "addressable/uri"
require "twitter/basic_user"
require "twitter/creatable"
require "twitter/entity/uri"
require "twitter/profile"

module Twitter
  # Represents a Twitter user
  class User < BasicUser
    include Creatable
    include Profile

    # The user's connections
    #
    # @api public
    # @example
    #   user.connections
    # @return [Array]
    attr_reader :connections

    # The number of favourites
    #
    # @api public
    # @example
    #   user.favourites_count
    # @return [Integer]

    # The number of followers
    #
    # @api public
    # @example
    #   user.followers_count
    # @return [Integer]

    # The number of friends (following)
    #
    # @api public
    # @example
    #   user.friends_count
    # @return [Integer]

    # The number of lists this user is on
    #
    # @api public
    # @example
    #   user.listed_count
    # @return [Integer]

    # The number of statuses/tweets
    #
    # @api public
    # @example
    #   user.statuses_count
    # @return [Integer]

    # The UTC offset in seconds
    #
    # @api public
    # @example
    #   user.utc_offset
    # @return [Integer]
    attr_reader :favourites_count, :followers_count, :friends_count,
                :listed_count, :statuses_count, :utc_offset

    # The user's description
    #
    # @api public
    # @example
    #   user.description
    # @return [String]

    # The user's email address
    #
    # @api public
    # @example
    #   user.email
    # @return [String]

    # The user's language
    #
    # @api public
    # @example
    #   user.lang
    # @return [String]

    # The user's location
    #
    # @api public
    # @example
    #   user.location
    # @return [String]

    # The user's name
    #
    # @api public
    # @example
    #   user.name
    # @return [String]

    # The profile background color
    #
    # @api public
    # @example
    #   user.profile_background_color
    # @return [String]

    # The profile link color
    #
    # @api public
    # @example
    #   user.profile_link_color
    # @return [String]

    # The profile sidebar border color
    #
    # @api public
    # @example
    #   user.profile_sidebar_border_color
    # @return [String]

    # The profile sidebar fill color
    #
    # @api public
    # @example
    #   user.profile_sidebar_fill_color
    # @return [String]

    # The profile text color
    #
    # @api public
    # @example
    #   user.profile_text_color
    # @return [String]

    # The user's time zone
    #
    # @api public
    # @example
    #   user.time_zone
    # @return [String]
    attr_reader :description, :email, :lang, :location, :name,
                :profile_background_color, :profile_link_color,
                :profile_sidebar_border_color, :profile_sidebar_fill_color,
                :profile_text_color, :time_zone

    # @!method favorites_count
    #   The number of favorites (US spelling)
    #   @api public
    #   @example
    #     user.favorites_count
    #   @return [Integer]
    alias favorites_count favourites_count

    # @!method tweets_count
    #   The number of tweets
    #   @api public
    #   @example
    #     user.tweets_count
    #   @return [Integer]
    alias tweets_count statuses_count
    object_attr_reader :Tweet, :status, :user

    # The user's latest tweet
    #
    # @!method tweet
    # @api public
    # @example
    #   user.tweet
    # @return [Twitter::Tweet]
    alias tweet status

    # Returns true if the user has a tweet
    #
    # @!method tweet?
    # @api public
    # @example
    #   user.tweet?
    # @return [Boolean]
    alias tweet? status?

    # Returns true if the user has tweeted
    #
    # @!method tweeted?
    # @api public
    # @example
    #   user.tweeted?
    # @return [Boolean]
    alias tweeted? status?
    predicate_attr_reader :contributors_enabled, :default_profile,
                          :default_profile_image, :follow_request_sent,
                          :geo_enabled, :muting, :needs_phone_verification,
                          :notifications, :protected, :profile_background_tile,
                          :profile_use_background_image, :suspended, :verified
    define_predicate_method :translator, :is_translator
    define_predicate_method :translation_enabled, :is_translation_enabled
    uri_attr_reader :profile_background_image_uri, :profile_background_image_uri_https

    # Returns an array of URIs in the user's description
    #
    # @api public
    # @example
    #   user.description_uris
    # @return [Array<Twitter::Entity::URI>]
    def description_uris
      empty_hash = {} #: Hash[Symbol, untyped]
      empty_array = [] #: Array[untyped]
      @attrs.fetch(:entities, empty_hash).fetch(:description, empty_hash).fetch(:urls, empty_array).collect do |url| # steep:ignore FallbackAny
        Entity::URI.new(url)
      end
    end
    memoize :description_uris

    # @!method description_urls
    #   Returns an array of URLs in the user's description
    #   @api public
    #   @example
    #     user.description_urls
    #   @return [Array<Twitter::Entity::URI>]
    alias description_urls description_uris

    # Returns true if the user has description URIs
    #
    # @api public
    # @example
    #   user.description_uris?
    # @return [Boolean]
    def description_uris?
      description_uris.any?
    end
    memoize :description_uris?

    # @!method description_urls?
    #   Returns true if the user has description URLs
    #   @api public
    #   @example
    #     user.description_urls?
    #   @return [Boolean]
    alias description_urls? description_uris?

    # Returns an array of URIs in the user's website
    #
    # @api public
    # @example
    #   user.website_uris
    # @return [Array<Twitter::Entity::URI>]
    def website_uris
      empty_hash = {} #: Hash[Symbol, untyped]
      empty_array = [] #: Array[untyped]
      @attrs.fetch(:entities, empty_hash).fetch(:url, empty_hash).fetch(:urls, empty_array).collect do |url| # steep:ignore FallbackAny
        Entity::URI.new(url)
      end
    end
    memoize :website_uris

    # @!method website_urls
    #   Returns an array of URLs in the user's website
    #   @api public
    #   @example
    #     user.website_urls
    #   @return [Array<Twitter::Entity::URI>]
    alias website_urls website_uris

    # Returns true if the user has website URIs
    #
    # @api public
    # @example
    #   user.website_uris?
    # @return [Boolean]
    def website_uris?
      website_uris.any?
    end
    memoize :website_uris?

    # @!method website_urls?
    #   Returns true if the user has website URLs
    #   @api public
    #   @example
    #     user.website_urls?
    #   @return [Boolean]
    alias website_urls? website_uris?

    # Returns true if the user has entities
    #
    # @api public
    # @example
    #   user.entities?
    # @return [Boolean]
    def entities?
      !@attrs[:entities].nil? && @attrs[:entities].any? { |_, hash| hash[:urls].any? }
    end
    memoize :entities?

    # Returns the URI to the user's profile
    #
    # @api public
    # @example
    #   user.uri
    # @return [Addressable::URI]
    def uri
      Addressable::URI.parse("https://twitter.com/#{screen_name}") if screen_name?
    end
    memoize :uri

    # @!method url
    #   Returns the URL to the user's profile
    #   @api public
    #   @example
    #     user.url
    #   @return [Addressable::URI]
    alias url uri

    # Returns the user's website URL
    #
    # @api public
    # @example
    #   user.website
    # @return [Addressable::URI]
    def website
      if website_uris?
        website_uris.first.expanded_url
      else
        Addressable::URI.parse(@attrs[:url])
      end
    end
    memoize :website

    # Returns true if the user has a website
    #
    # @api public
    # @example
    #   user.website?
    # @return [Boolean]
    def website?
      !!(website_uris? || @attrs[:url])
    end
    memoize :website?
  end
end
