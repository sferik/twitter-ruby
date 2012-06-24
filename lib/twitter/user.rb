require 'twitter/core_ext/hash'
require 'twitter/creatable'
require 'twitter/identifiable'
require 'twitter/status'

module Twitter
  class User < Twitter::Identifiable
    include Twitter::Creatable
    attr_reader :all_replies, :blocking, :can_dm, :connections,
      :contributors_enabled, :default_profile, :default_profile_image,
      :description, :favourites_count, :follow_request_sent, :followed_by,
      :followers_count, :following, :friends_count, :geo_enabled,
      :is_translator, :lang, :listed_count, :location, :marked_spam, :name,
      :notifications, :notifications_enabled, :profile_background_color,
      :profile_background_image_url, :profile_background_image_url_https,
      :profile_background_tile, :profile_image_url, :profile_image_url_https,
      :profile_link_color, :profile_sidebar_border_color,
      :profile_sidebar_fill_color, :profile_text_color,
      :profile_use_background_image, :protected, :screen_name, :statuses_count,
      :time_zone, :url, :utc_offset, :verified, :want_retweets
    alias all_replies? all_replies
    alias blocking? blocking
    alias can_dm? can_dm
    alias contributors_enabled? contributors_enabled
    alias default_profile? default_profile
    alias default_profile_image? default_profile_image
    alias follow_request_sent? follow_request_sent
    alias following? following
    alias followed_by? followed_by
    alias favorite_count favourites_count
    alias favorites_count favourites_count
    alias favourite_count favourites_count
    alias follower_count followers_count
    alias friend_count friends_count
    alias geo_enabled? geo_enabled
    alias is_translator? is_translator
    alias marked_spam? marked_spam
    alias notifications? notifications
    alias notifications_enabled? notifications_enabled
    alias profile_background_tile? profile_background_tile
    alias profile_use_background_image? profile_use_background_image
    alias protected? protected
    alias status_count statuses_count
    alias translator is_translator
    alias translator? is_translator
    alias tweet_count statuses_count
    alias tweets_count statuses_count
    alias update_count statuses_count
    alias updates_count statuses_count
    alias verified? verified
    alias want_retweets? want_retweets

    # @return [Twitter::Status]
    def status
      @status ||= Twitter::Status.fetch_or_new(@attrs.dup[:status].merge(:user => @attrs.except(:status))) unless @attrs[:status].nil?
    end

  end
end
