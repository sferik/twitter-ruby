require 'twitter/base'
require 'twitter/creatable'
require 'twitter/geo_factory'
require 'twitter/place'
require 'twitter/user'

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
      super || id == other.id
    end

    def geo
      Twitter::GeoFactory.new(@geo) if @geo
    end

    def place
      Twitter::Place.new(@place) if @place
    end

  end
end
