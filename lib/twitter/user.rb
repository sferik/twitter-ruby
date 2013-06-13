require 'twitter/basic_user'
require 'twitter/creatable'
require 'twitter/exceptable'

module Twitter
  class User < Twitter::BasicUser
    PROFILE_IMAGE_SUFFIX_REGEX = /_normal(\.gif|\.jpe?g|\.png)$/i
    include Twitter::Creatable
    include Twitter::Exceptable
    attr_reader :connections, :contributors_enabled, :default_profile,
      :default_profile_image, :description, :favourites_count,
      :follow_request_sent, :followers_count, :friends_count, :geo_enabled,
      :is_translator, :lang, :listed_count, :location, :name, :notifications,
      :profile_background_color, :profile_background_image_url,
      :profile_background_image_url_https, :profile_background_tile,
      :profile_link_color, :profile_sidebar_border_color,
      :profile_sidebar_fill_color, :profile_text_color,
      :profile_use_background_image, :protected, :statuses_count, :time_zone,
      :url, :utc_offset, :verified
    alias favorite_count favourites_count
    alias favoriters_count favourites_count
    alias favorites_count favourites_count
    alias favourite_count favourites_count
    alias favouriters_count favourites_count
    alias follower_count followers_count
    alias friend_count friends_count
    alias status_count statuses_count
    alias translator is_translator
    alias translator? is_translator?
    alias tweet_count statuses_count
    alias tweets_count statuses_count
    alias update_count statuses_count
    alias updates_count statuses_count

    # @return [Array<Twitter::Entity::Url>]
    def description_urls
      @description_urls ||= Array(@attrs[:entities][:description][:urls]).map do |entity|
        Twitter::Entity::Url.fetch_or_new(entity)
      end
    end

    # Return the URL to the user's profile banner image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mobile', 'mobile_retina', 'web', 'web_retina', 'ipad', or 'ipad_retina'
    # @return [String]
    def profile_banner_url(size=:web)
      insecure_url([@attrs[:profile_banner_url], size].join('/')) if profile_banner_url?
    end

    # Return the secure URL to the user's profile banner image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mobile', 'mobile_retina', 'web', 'web_retina', 'ipad', or 'ipad_retina'
    # @return [String]
    def profile_banner_url_https(size=:web)
      [@attrs[:profile_banner_url], size].join('/') if profile_banner_url?
    end

    def profile_banner_url?
      !@attrs[:profile_banner_url].nil?
    end
    alias profile_banner_url_https? profile_banner_url?

    # Return the URL to the user's profile image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mini', 'normal', 'bigger' or 'original'
    # @return [String]
    def profile_image_url(size=:normal)
      insecure_url(profile_image_url_https(size)) if profile_image_url?
    end

    # Return the secure URL to the user's profile image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mini', 'normal', 'bigger' or 'original'
    # @return [String]
    def profile_image_url_https(size=:normal)
      # The profile image URL comes in looking like like this:
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png
      # It can be converted to any of the following sizes:
      # https://a0.twimg.com/profile_images/1759857427/image1326743606.png
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png
      resize_profile_image_url(@attrs[:profile_image_url_https], size) if profile_image_url?
    end

    def profile_image_url?
      !@attrs[:profile_image_url_https].nil?
    end
    alias profile_image_url_https? profile_image_url?

    # @return [Twitter::Tweet]
    def status
      @status ||= fetch_or_new_without_self(Twitter::Tweet, @attrs, :status, :user)
    end

    def status?
      !@attrs[:status].nil?
    end

  private

    def insecure_url(url)
      url.sub(/^https/i, 'http')
    end

    def resize_profile_image_url(url, size)
      url.sub(PROFILE_IMAGE_SUFFIX_REGEX, profile_image_suffix(size))
    end

    def profile_image_suffix(size)
      if :original == size.to_sym
        "\\1"
      else
        "_#{size}\\1"
      end
    end

  end
end
