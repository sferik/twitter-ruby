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
    attr_reader :favorited, :from_user, :from_user_id, :geo, :hashtags, :id,
      :in_reply_to_screen_name, :in_reply_to_status_id, :in_reply_to_user_id,
      :iso_language_code, :metadata, :profile_image_url, :media, :place,
      :retweet_count, :retweeted, :source, :text, :to_user, :to_user_id,
      :truncated, :urls, :user, :user_mentions
    alias :favorited? :favorited
    alias :mentions :user_mentions
    alias :retweeted? :retweeted
    alias :truncated? :truncated

    def initialize(status={})
      @geo = Twitter::GeoFactory.new(status.delete('geo')) unless status['geo'].nil?
      @hashtags = Twitter::Extractor.extract_hashtags(status['text']) unless status['text'].nil?
      @media = status['entities'].delete('media').map do |medium|
        Twitter::MediaFactory.new(medium)
      end unless status['entities'].nil? || status['entities']['media'].nil?
      @metadata = Twitter::Metadata.new(status.delete('metadata')) unless status['metadata'].nil?
      @place = Twitter::Place.new(status.delete('place')) unless status['place'].nil?
      @urls = Twitter::Extractor.extract_urls(status['text']) unless status['text'].nil?
      @user = Twitter::User.new(status.delete('user').merge('status' => self.to_hash.delete('user'))) unless status['user'].nil?
      @user_mentions = Twitter::Extractor.extract_mentioned_screen_names(status['text']) unless status['text'].nil?
      super(status)
    end

    def ==(other)
      super || (other.class == self.class && other.instance_variable_get('@id'.to_sym) == @id)
    end

  end
end
