require 'twitter/base'
require 'twitter/creatable'
require 'twitter/geo_factory'
require 'twitter/media_factory'
require 'twitter/place'
require 'twitter/user'
require 'twitter-text'

module Twitter
  class Status < Twitter::Base
    include Twitter::Creatable
    attr_reader :id, :in_reply_to_screen_name, :in_reply_to_status_id,
      :in_reply_to_user_id, :favorited, :retweet_count, :retweeted, :source,
      :text, :truncated
    alias :favorited? :favorited
    alias :retweeted? :retweeted
    alias :truncated? :truncated

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def geo
      Twitter::GeoFactory.new(@geo) if @geo
    end

    def hashtags
      Twitter::Extractor.extract_hashtags(@text) if @text
    end

    def media
      if @entities
        @entities['media'].map do |media|
          MediaFactory.new(media)
        end
      end
    end

    def place
      Twitter::Place.new(@place) if @place
    end

    def urls
      Twitter::Extractor.extract_urls(@text) if @text
    end

    def user
      Twitter::User.new(@user.merge(:status => self.to_hash.delete(:user))) if @user
    end

    def user_mentions
      Twitter::Extractor.extract_mentioned_screen_names(@text) if @text
    end
    alias :mentions :user_mentions

  end
end
