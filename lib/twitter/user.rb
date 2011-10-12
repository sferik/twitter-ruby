require 'twitter/authenticatable'
require 'twitter/base'
require 'twitter/creatable'
require 'twitter/status'

module Twitter
  class User < Twitter::Base
    include Twitter::Authenticatable
    include Twitter::Creatable
    attr_reader :contributors_enabled, :default_profile,
      :default_profile_image, :description, :favourites_count,
      :follow_request_sent, :followers_count, :following, :friends_count,
      :geo_enabled, :id, :is_translator, :lang, :listed_count, :location,
      :name, :notifications, :profile_background_color,
      :profile_background_image_url, :profile_background_image_url_https,
      :profile_background_tile, :profile_image_url, :profile_image_url_https,
      :profile_link_color, :profile_sidebar_border_color,
      :profile_sidebar_fill_color, :profile_text_color,
      :profile_use_background_image, :protected, :screen_name,
      :statuses_count, :time_zone, :url, :utc_offset, :verified
    alias :contributors_enabled? :contributors_enabled
    alias :default_profile? :default_profile
    alias :default_profile_image? :default_profile_image
    alias :follow_request_sent? :follow_request_sent
    alias :following? :following
    alias :geo_enabled? :geo_enabled
    alias :is_translator? :is_translator
    alias :notifications? :notifications
    alias :profile_background_tile? :profile_background_tile
    alias :profile_use_background_image? :profile_use_background_image
    alias :protected? :protected
    alias :verified? :verified

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # Get a user's status
    #
    # @return [Status]
    def status
      Twitter::Status.new(@status.merge(:user => self.to_hash.delete(:status))) if @status
    end

  end
end
