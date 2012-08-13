require 'twitter/core_ext/hash'
require 'twitter/creatable'
require 'twitter/entity/hashtag'
require 'twitter/entity/url'
require 'twitter/entity/user_mention'
require 'twitter/geo_factory'
require 'twitter/identity'
require 'twitter/media_factory'
require 'twitter/metadata'
require 'twitter/place'
require 'twitter/user'

module Twitter
  class Tweet < Twitter::Identity
    include Twitter::Creatable
    attr_reader :favorited, :favoriters, :from_user_id, :from_user_name,
      :in_reply_to_screen_name, :in_reply_to_attrs_id, :in_reply_to_status_id,
      :in_reply_to_user_id, :iso_language_code, :profile_image_url,
      :profile_image_url_https, :repliers, :retweeted, :retweeters, :source,
      :text, :to_user, :to_user_id, :to_user_name, :truncated
    alias in_reply_to_tweet_id in_reply_to_status_id
    alias favorited? favorited
    alias favourited favorited
    alias favourited? favorited
    alias retweeted? retweeted
    alias truncated? truncated

    # @return [Integer]
    def favoriters_count
      favoriters_count = @attrs[:favoriters_count]
      favoriters_count.to_i if favoriters_count
    end
    alias favorite_count favoriters_count
    alias favourite_count favoriters_count
    alias favouriters_count favoriters_count

    # @return [String]
    def from_user
      @attrs[:from_user] || user && user.screen_name
    end

    # @return [String]
    # @note May be > 140 characters.
    def full_text
      retweeted_status && retweeted_status.user ? "RT @#{retweeted_status.user.screen_name}: #{retweeted_status.text}" : text
    end

    # @return [Twitter::Geo]
    def geo
      @geo ||= Twitter::GeoFactory.fetch_or_new(@attrs[:geo])
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

    # @return [Twitter::Metadata]
    def metadata
      @metadata ||= Twitter::Metadata.fetch_or_new(@attrs[:metadata])
    end

    # @deprecated This method will be removed in version 4.
    # @return [Twitter::OEmbed]
    def oembed(options={})
      @oembed ||= Twitter.oembed(@attrs[:id], options)
    end

    # @return [Twitter::Place]
    def place
      @place ||= Twitter::Place.fetch_or_new(@attrs[:place])
    end

    # @return [Integer]
    def repliers_count
      repliers_count = @attrs[:repliers_count]
      repliers_count.to_i if repliers_count
    end
    alias reply_count repliers_count

    # If this Tweet is a retweet, the original Tweet is available here.
    #
    # @return [Twitter::Tweet]
    def retweeted_status
      @retweeted_status ||= self.class.fetch_or_new(@attrs[:retweeted_status])
    end
    alias retweeted_tweet retweeted_status

    # @return [String]
    def retweeters_count
      retweeters_count = (@attrs[:retweet_count] || @attrs[:retweeters_count])
      retweeters_count.to_i if retweeters_count
    end
    alias retweet_count retweeters_count

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::Url>]
    def urls
      @urls ||= entities(Twitter::Entity::Url, :urls)
    end

    # @return [Twitter::User]
    def user
      @user ||= Twitter::User.fetch_or_new(@attrs.dup[:user].merge(:status => @attrs.except(:user))) unless @attrs[:user].nil?
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<Twitter::Entity::UserMention>]
    def user_mentions
      @user_mentions ||= entities(Twitter::Entity::UserMention, :user_mentions)
    end

  private

    # @param klass [Class]
    # @param method [Symbol]
    def entities(klass, method)
      if @attrs[:entities].nil?
        warn "#{Kernel.caller.first}: To get #{method.to_s.tr('_', ' ')}, you must pass `:include_entities => true` when requesting the #{self.class.name}."
        []
      else
        Array(@attrs[:entities][method.to_sym]).map do |user_mention|
          klass.fetch_or_new(user_mention)
        end
      end
    end

  end

  Status = Tweet
end
