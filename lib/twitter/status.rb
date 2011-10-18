require 'twitter/base'
require 'twitter/creatable'
require 'twitter/geo_factory'
require 'twitter/media_factory'
require 'twitter/metadata'
require 'twitter/place'
require 'twitter/user'
require 'twitter-text'

module Twitter
  class Status < Twitter::Base
    include Twitter::Creatable
    attr_reader :geo, :hashtags, :media, :metadata, :place, :urls, :user,
      :user_mentions
    lazy_attr_reader :favorited, :from_user, :from_user_id, :id,
      :in_reply_to_screen_name, :in_reply_to_attributes_id, :in_reply_to_user_id,
      :iso_language_code, :profile_image_url, :retweet_count, :retweeted,
      :source, :text, :to_user, :to_user_id, :truncated
    alias :favorited? :favorited
    alias :mentions :user_mentions
    alias :retweeted? :retweeted
    alias :truncated? :truncated

    def initialize(attributes={})
      attributes = attributes.dup
      @geo = Twitter::GeoFactory.new(attributes.delete('geo')) unless attributes['geo'].nil?
      @hashtags = Twitter::Extractor.extract_hashtags(attributes['text']) unless attributes['text'].nil?
      @media = attributes['entities'].delete('media').map do |media|
        Twitter::MediaFactory.new(media)
      end unless attributes['entities'].nil? || attributes['entities']['media'].nil?
      @metadata = Twitter::Metadata.new(attributes.delete('metadata')) unless attributes['metadata'].nil?
      @place = Twitter::Place.new(attributes.delete('place')) unless attributes['place'].nil?
      @urls = Twitter::Extractor.extract_urls(attributes['text']) unless attributes['text'].nil?
      @user = Twitter::User.new(attributes.delete('user')) unless attributes['user'].nil?
      @user_mentions = Twitter::Extractor.extract_mentioned_screen_names(attributes['text']) unless attributes['text'].nil?
      super(attributes)
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
