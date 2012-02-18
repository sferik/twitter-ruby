require 'active_support/core_ext/hash/except'
require 'twitter/base'
require 'twitter/client'
require 'twitter/creatable'
require 'twitter/geo_factory'
require 'twitter/media_factory'
require 'twitter/metadata'
require 'twitter/oembed'
require 'twitter/place'
require 'twitter/user'

module Twitter
  class Status < Twitter::Base
    include Twitter::Creatable
    lazy_attr_reader :favorited, :from_user, :from_user_id, :from_user_name, :id,
      :in_reply_to_screen_name, :in_reply_to_attrs_id, :in_reply_to_status_id,
      :in_reply_to_user_id, :iso_language_code, :profile_image_url,
      :retweet_count, :retweeted, :source, :text, :to_user, :to_user_id, :to_user_name,
      :truncated
    alias :favorited? :favorited
    alias :retweeted? :retweeted
    alias :truncated? :truncated

    # @param other [Twiter::Status]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @note Must :include_entities in your request for this method to work
    # @return [Array<String>]
    def expanded_urls
      @expanded_urls ||= Array(@attrs['entities']['urls']).map do |url|
        url['expanded_url']
      end unless @attrs['entities'].nil?
    end

    # @return [Twitter::Point, Twitter::Polygon]
    def geo
      @geo ||= Twitter::GeoFactory.new(@attrs['geo']) unless @attrs['geo'].nil?
    end

    # @note Must :include_entities in your request for this method to work
    # @return [Array]
    def media
      @media ||= Array(@attrs['entities']['media']).map do |media|
        Twitter::MediaFactory.new(media)
      end unless @attrs['entities'].nil?
    end

    # @return [Twitter::Metadata]
    def metadata
      @metadata ||= Twitter::Metadata.new(@attrs['metadata']) unless @attrs['metadata'].nil?
    end

    # @return [Twitter::Place]
    def place
      @place ||= Twitter::Place.new(@attrs['place']) unless @attrs['place'].nil?
    end

    # @return [Twitter::User]
    def user
      @user ||= Twitter::User.new(@attrs.dup['user'].merge('status' => @attrs.except('user'))) unless @attrs['user'].nil?
    end

    # If this status is itself a retweet, the original tweet is available here.
    #
    # @return [Twitter::Status]
    def retweeted_status
      @retweeted_status ||= self.class.new(@attrs['retweeted_status']) unless @attrs['retweeted_status'].nil?
    end

    # @return [Twitter::OEmbed]
    def oembed(options={})
      @client ||= Twitter::Client.new
      @client.oembed(@attrs['id'], options) unless @attrs['id'].nil?
    end

  end
end
