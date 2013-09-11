require 'twitter/basic_user'
require 'twitter/creatable'

module Twitter
  class User < Twitter::BasicUser
    PROFILE_IMAGE_SUFFIX_REGEX = /_normal(\.gif|\.jpe?g|\.png)$/i
    include Twitter::Creatable
    attr_reader :connections, :contributors_enabled, :default_profile,
      :default_profile_image, :description, :favourites_count,
      :follow_request_sent, :followers_count, :friends_count, :geo_enabled,
      :is_translator, :lang, :listed_count, :location, :name, :notifications,
      :profile_background_color, :profile_background_image_url,
      :profile_background_image_url_https, :profile_background_tile,
      :profile_link_color, :profile_sidebar_border_color,
      :profile_sidebar_fill_color, :profile_text_color,
      :profile_use_background_image, :protected, :statuses_count, :time_zone,
      :utc_offset, :verified
    alias favorites_count favourites_count
    alias profile_background_image_uri profile_background_image_url
    alias profile_background_image_uri_https profile_background_image_url_https
    alias translator? is_translator
    alias tweets_count statuses_count
    object_attr_reader :Tweet, :status, :user
    alias tweet status
    alias tweet? status?
    alias tweeted? status?

    # @return [Array<Twitter::Entity::Url>]
    def description_uris
      memoize(:description_urls) do
        Array(@attrs[:entities][:description][:urls]).map do |entity|
          Twitter::Entity::Url.new(entity)
        end
      end
    end
    alias description_urls description_uris

    # Return the URL to the user's profile banner image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mobile', 'mobile_retina', 'web', 'web_retina', 'ipad', or 'ipad_retina'
    # @return [String]
    def profile_banner_uri(size=:web)
      parse_encoded_uri(insecure_uri([@attrs[:profile_banner_url], size].join('/'))) if @attrs[:profile_banner_url]
    end
    alias profile_banner_url profile_banner_uri

    # Return the secure URL to the user's profile banner image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mobile', 'mobile_retina', 'web', 'web_retina', 'ipad', or 'ipad_retina'
    # @return [String]
    def profile_banner_uri_https(size=:web)
      parse_encoded_uri([@attrs[:profile_banner_url], size].join('/')) if @attrs[:profile_banner_url]
    end
    alias profile_banner_url_https profile_banner_uri_https

    def profile_banner_uri?
      !!@attrs[:profile_banner_url]
    end
    alias profile_banner_url? profile_banner_uri?
    alias profile_banner_uri_https? profile_banner_uri?
    alias profile_banner_url_https? profile_banner_uri?

    # Return the URL to the user's profile image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mini', 'normal', 'bigger' or 'original'
    # @return [String]
    def profile_image_uri(size=:normal)
      parse_encoded_uri(insecure_uri(profile_image_uri_https(size))) if @attrs[:profile_image_url_https]
    end
    alias profile_image_url profile_image_uri

    # Return the secure URL to the user's profile image
    #
    # @param size [String, Symbol] The size of the image. Must be one of: 'mini', 'normal', 'bigger' or 'original'
    # @return [String]
    def profile_image_uri_https(size=:normal)
      # The profile image URL comes in looking like like this:
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png
      # It can be converted to any of the following sizes:
      # https://a0.twimg.com/profile_images/1759857427/image1326743606.png
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png
      parse_encoded_uri(@attrs[:profile_image_url_https].sub(PROFILE_IMAGE_SUFFIX_REGEX, profile_image_suffix(size))) if @attrs[:profile_image_url_https]
    end
    alias profile_image_url_https profile_image_uri_https

    def profile_image_uri?
      !!@attrs[:profile_image_url_https]
    end
    alias profile_image_url? profile_image_uri?
    alias profile_image_uri_https? profile_image_uri?
    alias profile_image_url_https? profile_image_uri?

    # @return [String] The URL to the user.
    def uri
      @uri ||= ::URI.parse("https://twitter.com/#{screen_name}")
    end
    alias url uri

    # @return [String] The URL to the user's website.
    def website
      @website ||= ::URI.parse(@attrs[:url]) if @attrs[:url]
    end

    def website?
      !!@attrs[:url]
    end

  private

    def parse_encoded_uri(uri)
      ::URI.parse(::URI.encode(uri))
    end

    def insecure_uri(uri)
      uri.to_s.sub(/^https/i, 'http')
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
