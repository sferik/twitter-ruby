require 'twitter/client'
require 'twitter/core_ext/hash'
require 'twitter/creatable'
require 'twitter/entity/hashtag'
require 'twitter/entity/url'
require 'twitter/entity/user_mention'
require 'twitter/geo_factory'
require 'twitter/identifiable'
require 'twitter/media_factory'
require 'twitter/metadata'
require 'twitter/oembed'
require 'twitter/place'
require 'twitter/user'

module Twitter
  class Status < Twitter::Identifiable
    include Twitter::Creatable
    attr_reader :favorited, :favoriters, :favoriters_count, :from_user,
      :from_user_id, :from_user_name, :in_reply_to_screen_name,
      :in_reply_to_attrs_id, :in_reply_to_status_id, :in_reply_to_user_id,
      :iso_language_code, :profile_image_url, :profile_image_url_https,
      :repliers, :repliers_count, :retweeted, :retweeters, :retweeters_count,
      :source, :text, :to_user, :to_user_id, :to_user_name, :truncated
    alias :favorited? :favorited
    alias :favorite_count :favoriters_count
    alias :reply_count :repliers_count
    alias :retweet_count :retweeters_count
    alias :retweeted? :retweeted
    alias :truncated? :truncated

    # @param other [Twitter::Status]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [String]
    def from_user
      @attrs['from_user'] || self.user && self.user.screen_name
    end

    # @return [String]
    # @note May be > 140 characters.
    def full_text
      self.retweeted_status && self.retweeted_status.user ? "RT @#{self.retweeted_status.user.screen_name}: #{self.retweeted_status.text}" : self.text
    end

    # @return [Twitter::Point, Twitter::Polygon]
    def geo
      @geo ||= Twitter::GeoFactory.new(@attrs['geo']) unless @attrs['geo'].nil?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Hashtag>]
    def hashtags
      @hashtags ||= unless @attrs['entities'].nil?
        Array(@attrs['entities']['hashtags']).map do |hashtag|
          Twitter::Entity::Hashtag.get_or_new(hashtag)
        end
      else
        warn "#{Kernel.caller.first}: To get hashtags, you must pass `:include_entities => true` when requesting the Twitter::Status."
      end
    end

    # @note Must include entities in your request for this method to work
    # @return [Array]
    def media
      @media ||= unless @attrs['entities'].nil?
        Array(@attrs['entities']['media']).map do |media|
          Twitter::MediaFactory.new(media)
        end
      else
        warn "#{Kernel.caller.first}: To get media, you must pass `:include_entities => true` when requesting the Twitter::Status."
      end
    end

    # @return [Twitter::Metadata]
    def metadata
      @metadata ||= Twitter::Metadata.get_or_new(@attrs['metadata']) unless @attrs['metadata'].nil?
    end

    # @return [Twitter::OEmbed]
    def oembed(options={})
      @client ||= Twitter::Client.new
      @client.oembed(@attrs['id'], options) unless @attrs['id'].nil?
    end

    # @return [Twitter::Place]
    def place
      @place ||= Twitter::Place.get_or_new(@attrs['place']) unless @attrs['place'].nil?
    end

    # If this status is itself a retweet, the original tweet is available here.
    #
    # @return [Twitter::Status]
    def retweeted_status
      @retweeted_status ||= self.class.get_or_new(@attrs['retweeted_status']) unless @attrs['retweeted_status'].nil?
    end

    # @note If retweeters_count is > 50 it will return the string 50+.
    # @return [String]
    def retweeters_count
      @attrs['retweet_count'] || @attrs['retweeters_count']
    end
    alias :retweet_count :retweeters_count

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Url>]
    def urls
      @urls ||= unless @attrs['entities'].nil?
        Array(@attrs['entities']['urls']).map do |url|
          Twitter::Entity::Url.get_or_new(url)
        end
      else
        warn "#{Kernel.caller.first}: To get URLs, you must pass `:include_entities => true` when requesting the Twitter::Status."
      end
    end

    # @return [Twitter::User]
    def user
      @user ||= Twitter::User.get_or_new(@attrs.dup['user'].merge('status' => @attrs.except('user'))) unless @attrs['user'].nil?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::UserMention>]
    def user_mentions
      @user_mentions ||= unless @attrs['entities'].nil?
        Array(@attrs['entities']['user_mentions']).map do |user_mention|
          Twitter::Entity::UserMention.get_or_new(user_mention)
        end
      else
        warn "#{Kernel.caller.first}: To get user mentions, you must pass `:include_entities => true` when requesting the Twitter::Status."
      end
    end

  end
end
