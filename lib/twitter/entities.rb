require "memoizable"
require "twitter/entity/hashtag"
require "twitter/entity/symbol"
require "twitter/entity/uri"
require "twitter/entity/user_mention"
require "twitter/media_factory"

module Twitter
  # Provides methods for accessing entities in tweets
  module Entities
    include Memoizable

    # Returns true if the object has any entities
    #
    # @api public
    # @example
    #   tweet.entities?
    # @return [Boolean]
    def entities?
      !@attrs[:entities].nil? && @attrs[:entities].any? { |_, array| array.any? } # steep:ignore FallbackAny
    end
    memoize :entities?

    # Returns an array of hashtags in the object
    #
    # @api public
    # @note Must include entities in your request for this method to work
    # @example
    #   tweet.hashtags
    # @return [Array<Twitter::Entity::Hashtag>]
    def hashtags
      entities(Entity::Hashtag, :hashtags)
    end
    memoize :hashtags

    # Returns true if the object has any hashtags
    #
    # @api public
    # @example
    #   tweet.hashtags?
    # @return [Boolean]
    def hashtags?
      hashtags.any?
    end
    memoize :hashtags?

    # Returns an array of media in the object
    #
    # @api public
    # @note Must include entities in your request for this method to work
    # @example
    #   tweet.media
    # @return [Array<Twitter::Media>]
    def media
      extended_entities = entities(MediaFactory, :media, :extended_entities)
      extended_entities.empty? ? entities(MediaFactory, :media) : extended_entities
    end
    memoize :media

    # Returns true if the object has any media
    #
    # @api public
    # @example
    #   tweet.media?
    # @return [Boolean]
    def media?
      media.any?
    end
    memoize :media?

    # Returns an array of symbols in the object
    #
    # @api public
    # @note Must include entities in your request for this method to work
    # @example
    #   tweet.symbols
    # @return [Array<Twitter::Entity::Symbol>]
    def symbols
      entities(Entity::Symbol, :symbols)
    end
    memoize :symbols

    # Returns true if the object has any symbols
    #
    # @api public
    # @example
    #   tweet.symbols?
    # @return [Boolean]
    def symbols?
      symbols.any?
    end
    memoize :symbols?

    # Returns an array of URIs in the object
    #
    # @api public
    # @note Must include entities in your request for this method to work
    # @example
    #   tweet.uris
    # @return [Array<Twitter::Entity::URI>]
    def uris
      entities(Entity::URI, :urls)
    end
    memoize :uris

    # @!method urls
    #   Returns an array of URLs in the object
    #   @api public
    #   @example
    #     tweet.urls
    #   @return [Array<Twitter::Entity::URI>]
    alias urls uris

    # Returns true if the object has any URIs
    #
    # @api public
    # @example
    #   tweet.uris?
    # @return [Boolean]
    def uris?
      uris.any?
    end

    # @!method urls?
    #   Returns true if the object has any URLs
    #   @api public
    #   @example
    #     tweet.urls?
    #   @return [Boolean]
    alias urls? uris?

    # Returns an array of user mentions in the object
    #
    # @api public
    # @note Must include entities in your request for this method to work
    # @example
    #   tweet.user_mentions
    # @return [Array<Twitter::Entity::UserMention>]
    def user_mentions
      entities(Entity::UserMention, :user_mentions)
    end
    memoize :user_mentions

    # Returns true if the object has any user mentions
    #
    # @api public
    # @example
    #   tweet.user_mentions?
    # @return [Boolean]
    def user_mentions?
      user_mentions.any?
    end
    memoize :user_mentions?

  private

    # Extracts entities of a given type from the attributes
    #
    # @api private
    # @param klass [Class] The class to instantiate for each entity
    # @param key2 [Symbol] The key within the entities hash
    # @param key1 [Symbol] The top-level key containing entities
    # @return [Array]
    def entities(klass, key2, key1 = :entities)
      empty_hash = {} #: Hash[Symbol, untyped]
      empty_array = [] #: Array[untyped]
      @attrs.fetch(key1.to_sym, empty_hash).fetch(key2.to_sym, empty_array).collect do |entity| # steep:ignore FallbackAny
        klass.new(entity)
      end
    end
  end
end
