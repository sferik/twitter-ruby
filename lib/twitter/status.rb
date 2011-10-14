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
      @created_at = status['created_at']
      @favorited = status['favorited']
      @from_user = status['from_user']
      @from_user_id = status['from_user_id']
      @geo = Twitter::GeoFactory.new(status['geo']) unless status['geo'].nil?
      @hashtags = Twitter::Extractor.extract_hashtags(status['text']) unless status['text'].nil?
      @id = status['id']
      @in_reply_to_screen_name = status['in_reply_to_screen_name']
      @in_reply_to_status_id = status['in_reply_to_status_id']
      @in_reply_to_user_id = status['in_reply_to_user_id']
      @iso_language_code = status['iso_language_code']
      @media = status['entities']['media'].map do |media|
        MediaFactory.new(media)
      end unless status['entities'].nil? || status['entities']['media'].nil?
      @metadata = Twitter::Metadata.new(status['metadata']) unless status['metadata'].nil?
      @place = Twitter::Place.new(status['place']) unless status['place'].nil?
      @profile_image_url = status['profile_image_url']
      @retweet_count = status['retweet_count']
      @retweeted = status['retweeted']
      @source = status['source']
      @text = status['text']
      @to_user = status['to_user']
      @to_user_id = status['to_user_id']
      @truncated = status['truncated']
      @urls = Twitter::Extractor.extract_urls(status['text']) unless status['text'].nil?
      @user = Twitter::User.new(status['user'].merge('status' => self.to_hash.delete('user'))) unless status['user'].nil?
      @user_mentions = Twitter::Extractor.extract_mentioned_screen_names(status['text']) unless status['text'].nil?
    end

    def ==(other)
      super || (other.class == self.class && other.id == @id)
    end
  end
end
