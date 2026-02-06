require "addressable/uri"
require "twitter/basic_user"
require "twitter/creatable"
require "twitter/entity/uri"
require "twitter/profile"

module Twitter
  # Represents a Twitter user
  class User < Twitter::BasicUser
    include Twitter::Creatable
    include Twitter::Profile

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

    class << self
    private

      # Dynamically defines methods for entity URIs
      #
      # @api private
      # @param key1 [Symbol] The method name
      # @param key2 [Symbol] The entity key
      # @return [void]
      def define_entity_uris_methods(key1, key2)
        array = key1.to_s.split("_")
        index = array.index("uris")
        array[index] = "urls"
        url_key = array.join("_").to_sym
        define_entity_uris_method(key1, key2)
        alias_method(url_key, key1)
        define_entity_uris_predicate_method(key1)
        alias_method(:"#{url_key}?", :"#{key1}?")
      end

      # Defines an entity URIs method
      #
      # @api private
      # @param key1 [Symbol] The method name
      # @param key2 [Symbol] The entity key
      # @return [void]
      def define_entity_uris_method(key1, key2)
        define_method(key1) do
          @attrs.fetch(:entities, {}).fetch(key2, {}).fetch(:urls, []).collect do |url|
            Entity::URI.new(url)
          end
        end
        memoize(key1)
      end

      # Defines an entity URIs predicate method
      #
      # @api private
      # @param key1 [Symbol] The method name
      # @return [void]
      def define_entity_uris_predicate_method(key1)
        define_method(:"#{key1}?") do
          send(:"#{key1}").any?
        end
        memoize(:"#{key1}?")
      end
    end

    define_entity_uris_methods :description_uris, :description
    define_entity_uris_methods :website_uris, :url

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
