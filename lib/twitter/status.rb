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
      :in_reply_to_screen_name, :in_reply_to_attrs_id, :in_reply_to_user_id,
      :iso_language_code, :profile_image_url, :retweet_count, :retweeted,
      :source, :text, :to_user, :to_user_id, :truncated
    alias :favorited? :favorited
    alias :retweeted? :retweeted
    alias :truncated? :truncated

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def all_urls
      @all_urls ||= begin
        all_urls = [ urls, expanded_urls ].compact.flatten.uniq
        all_urls.length > 0 ? all_urls : nil
      end
    end

    def expanded_urls
      @expanded_urls ||= Array(@attrs['entities']['urls']).map do |url|
        url['expanded_url']
      end unless @attrs['entities'].nil?
    end

    def geo
      @geo ||= Twitter::GeoFactory.new(@attrs['geo']) unless @attrs['geo'].nil?
    end

    def hashtags
      @hashtags ||= Twitter::Extractor.extract_hashtags(@attrs['text']) unless @attrs['text'].nil?
    end

    def media
      @media ||= Array(@attrs['entities']['media']).map do |media|
        Twitter::MediaFactory.new(media)
      end unless @attrs['entities'].nil?
    end

    def metadata
      @metadata ||= Twitter::Metadata.new(@attrs['metadata']) unless @attrs['metadata'].nil?
    end

    def place
      @place ||= Twitter::Place.new(@attrs['place']) unless @attrs['place'].nil?
    end

    def urls
      @urls ||= Twitter::Extractor.extract_urls(@attrs['text']) unless @attrs['text'].nil?
    end

    def user
      @user ||= Twitter::User.new(@attrs['user'].merge('status' => self.to_hash.delete_if{|key, value| key == 'user'})) unless @attrs['user'].nil?
    end

    def user_mentions
      @user_mentions ||= Twitter::Extractor.extract_mentioned_screen_names(@attrs['text']) unless @attrs['text'].nil?
    end
    alias :mentions :user_mentions

  end
end
