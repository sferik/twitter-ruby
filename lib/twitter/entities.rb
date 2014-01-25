require 'memoizable'
require 'twitter/entity/hashtag'
require 'twitter/entity/symbol'
require 'twitter/entity/uri'
require 'twitter/entity/user_mention'
require 'twitter/media_factory'

module Twitter
  module Entities
    include Memoizable

    # @return [Array<Symbol>]
    def entities
      @attrs.fetch(:entities, {}).reject{ |_, value| value.empty? }.keys
    end

    # @return [Boolean]
    def entities?
      !@attrs[:entities].nil? && @attrs[:entities].any? { |_, array| !array.empty? }
    end
    memoize :entities?

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Hashtag>]
    def hashtags
      entities_for(Entity::Hashtag, :hashtags)
    end
    memoize :hashtags

    # @return [Boolean]
    def hashtags?
      hashtags.any?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Media>]
    def media
      entities_for(MediaFactory, :media)
    end
    memoize :media

    # @return [Boolean]
    def media?
      media.any?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Symbol>]
    def symbols
      entities_for(Entity::Symbol, :symbols)
    end
    memoize :symbols

    # @return [Boolean]
    def symbols?
      symbols.any?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::URI>]
    def uris
      entities_for(Entity::URI, :urls)
    end
    memoize :uris
    alias_method :urls, :uris

    # @return [Boolean]
    def uris?
      uris.any?
    end
    alias_method :urls?, :uris?

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::UserMention>]
    def user_mentions
      entities_for(Entity::UserMention, :user_mentions)
    end
    memoize :user_mentions

    # @return [Boolean]
    def user_mentions?
      user_mentions.any?
    end

  private

    # @param klass [Class]
    # @param key [Symbol]
    def entities_for(klass, key)
      if entities?
        Array(@attrs[:entities][key.to_sym]).collect do |entity|
          klass.new(entity)
        end
      else
        warn "#{Kernel.caller.first}: To get #{key.to_s.tr('_', ' ')}, you must pass `:include_entities => true` when requesting the #{self.class}."
        []
      end
    end
  end
end
