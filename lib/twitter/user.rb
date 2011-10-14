require 'twitter/authenticatable'
require 'twitter/base'
require 'twitter/creatable'
require 'twitter/status'

module Twitter
  class User < Twitter::Base
    include Twitter::Authenticatable
    include Twitter::Creatable
    attr_reader :all_replies, :blocking, :can_dm, :contributors_enabled,
      :default_profile, :default_profile_image, :description,
      :favourites_count, :follow_request_sent, :followed_by, :followers_count,
      :following, :friends_count, :geo_enabled, :id, :is_translator, :lang,
      :listed_count, :location, :marked_spam, :name, :notifications,
      :notifications_enabled, :profile_background_color,
      :profile_background_image_url, :profile_background_image_url_https,
      :profile_background_tile, :profile_image_url, :profile_image_url_https,
      :profile_link_color, :profile_sidebar_border_color,
      :profile_sidebar_fill_color, :profile_text_color,
      :profile_use_background_image, :protected, :screen_name, :status,
      :statuses_count, :time_zone, :url, :utc_offset, :verified, :want_retweets
    alias :all_replies? :all_replies
    alias :blocking? :blocking
    alias :can_dm? :can_dm
    alias :contributors_enabled? :contributors_enabled
    alias :default_profile? :default_profile
    alias :default_profile_image? :default_profile_image
    alias :follow_request_sent? :follow_request_sent
    alias :following? :following
    alias :followed_by? :followed_by
    alias :favorites :favourites_count
    alias :favorites_count :favourites_count
    alias :favourites :favourites_count
    alias :followers :followers_count
    alias :friends :friends_count
    alias :geo_enabled? :geo_enabled
    alias :is_translator? :is_translator
    alias :listed :listed_count
    alias :marked_spam? :marked_spam
    alias :notifications? :notifications
    alias :notifications_enabled? :notifications_enabled
    alias :profile_background_tile? :profile_background_tile
    alias :profile_use_background_image? :profile_use_background_image
    alias :protected? :protected
    alias :statuses :statuses_count
    alias :translator :is_translator
    alias :translator? :is_translator
    alias :updates :statuses_count
    alias :verified? :verified
    alias :want_retweets? :want_retweets

    def initialize(user={})
      @contributors_enabled = user['contributors_enabled']
      @created_at = user['created_at']
      @default_profile = user['default_profile']
      @default_profile_image = user['default_profile_image']
      @description = user['description']
      @favourites_count = user['favourites_count']
      @follow_request_sent = user['follow_request_sent']
      @followers_count = user['followers_count']
      @following = user['following']
      @friends_count = user['friends_count']
      @geo_enabled = user['geo_enabled']
      @id = user['id']
      @is_translator = user['is_translator']
      @lang = user['lang']
      @listed_count = user['listed_count']
      @location = user['location']
      @name = user['name']
      @notifications = user['notifications']
      @profile_background_color = user['profile_background_color']
      @profile_background_image_url = user['profile_background_image_url']
      @profile_background_image_url_https = user['profile_background_image_url_https']
      @profile_background_tile = user['profile_background_tile']
      @profile_image_url = user['profile_image_url']
      @profile_image_url_https = user['profile_image_url_https']
      @profile_link_color = user['profile_link_color']
      @profile_sidebar_border_color = user['profile_sidebar_border_color']
      @profile_sidebar_fill_color = user['profile_sidebar_fill_color']
      @profile_text_color = user['profile_text_color']
      @profile_use_background_image = user['profile_use_background_image']
      @protected = user['protected']
      @screen_name = user['screen_name']
      @status = Twitter::Status.new(user['status'].merge('user' => self.to_hash.delete('status'))) unless user['status'].nil?
      @statuses_count = user['statuses_count']
      @time_zone = user['time_zone']
      @url = user['url']
      @utc_offset = user['utc_offset']
      @verified = user['verified']
    end

    def ==(other)
      super || (other.class == self.class && other.id == @id)
    end
  end
end
