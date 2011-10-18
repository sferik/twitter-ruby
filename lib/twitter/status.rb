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
    lazy_attr_reader :favorited, :from_user, :from_user_id, :id,
      :in_reply_to_screen_name, :in_reply_to_attributes_id, :in_reply_to_user_id,
      :iso_language_code, :profile_image_url, :retweet_count, :retweeted,
      :source, :text, :to_user, :to_user_id, :truncated
    alias :favorited? :favorited
    alias :retweeted? :retweeted
    alias :truncated? :truncated

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def expanded_urls
      @expanded_urls ||= Array(@attributes['entities']['urls']).map do |url|
        url['expanded_url']
      end unless @attributes['entities'].nil?
    end

    def geo
      @geo ||= Twitter::GeoFactory.new(@attributes['geo']) unless @attributes['geo'].nil?
    end

    def hashtags
      @hashtags ||= Twitter::Extractor.extract_hashtags(@attributes['text']) unless @attributes['text'].nil?
    end

    def media
      @media ||= Array(@attributes['entities']['media']).map do |media|
        Twitter::MediaFactory.new(media)
      end unless @attributes['entities'].nil?
    end

    def metadata
      @metadata ||= Twitter::Metadata.new(@attributes['metadata']) unless @attributes['metadata'].nil?
    end

    def place
      @place ||= Twitter::Place.new(@attributes['place']) unless @attributes['place'].nil?
    end

    def urls
      @urls ||= Twitter::Extractor.extract_urls(@attributes['text']) unless @attributes['text'].nil?
    end

    def user
      @user ||= Twitter::User.new(@attributes['user'].merge('status' => self.to_hash.delete_if{|key, value| key == 'user'})) unless @attributes['user'].nil?
    end

    def user_mentions
      @user_mentions ||= Twitter::Extractor.extract_mentioned_screen_names(@attributes['text']) unless @attributes['text'].nil?
    end
    alias :mentions :user_mentions

  end
end
