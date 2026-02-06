require "addressable/uri"
require "cgi"
require "memoizable"

module Twitter
  # Provides profile image and banner URL methods
  module Profile
    # Regular expression for profile image suffix
    PROFILE_IMAGE_SUFFIX_REGEX = /_normal(\.gif|\.jpe?g|\.png)$/i
    include Memoizable


    # Returns the URL to the user's profile banner image
    #
    # @api public
    # @example
    #   user.profile_banner_uri(:web)
    # @param size [String, Symbol] The size of the image
    # @return [Addressable::URI]
    def profile_banner_uri(size = :web)
      parse_uri(insecure_uri([@attrs[:profile_banner_url], size].join("/"))) unless @attrs[:profile_banner_url].nil? # steep:ignore FallbackAny
    end

    # @!method profile_banner_url
    #   Returns the URL to the user's profile banner image
    #   @api public
    #   @example
    #     user.profile_banner_url(:web)
    #   @return [Addressable::URI]
    alias profile_banner_url profile_banner_uri

    # Returns the secure URL to the user's profile banner image
    #
    # @api public
    # @example
    #   user.profile_banner_uri_https(:web)
    # @param size [String, Symbol] The size of the image
    # @return [Addressable::URI]
    def profile_banner_uri_https(size = :web)
      parse_uri([@attrs[:profile_banner_url], size].join("/")) unless @attrs[:profile_banner_url].nil? # steep:ignore FallbackAny
    end

    # @!method profile_banner_url_https
    #   Returns the secure URL to the user's profile banner image
    #   @api public
    #   @example
    #     user.profile_banner_url_https(:web)
    #   @return [Addressable::URI]
    alias profile_banner_url_https profile_banner_uri_https

    # Returns true if the user has a profile banner
    #
    # @api public
    # @example
    #   user.profile_banner_uri?
    # @return [Boolean]
    def profile_banner_uri?
      !!@attrs[:profile_banner_url] # steep:ignore FallbackAny
    end
    memoize :profile_banner_uri?
    alias profile_banner_url? profile_banner_uri?
    alias profile_banner_uri_https? profile_banner_uri?
    alias profile_banner_url_https? profile_banner_uri?

    # Returns the URL to the user's profile image
    #
    # @api public
    # @example
    #   user.profile_image_uri(:normal)
    # @param size [String, Symbol] The size of the image
    # @return [Addressable::URI]
    def profile_image_uri(size = :normal)
      parse_uri(insecure_uri(profile_image_uri_https(size))) unless @attrs[:profile_image_url_https].nil? # steep:ignore FallbackAny
    end

    # @!method profile_image_url
    #   Returns the URL to the user's profile image
    #   @api public
    #   @example
    #     user.profile_image_url(:normal)
    #   @return [Addressable::URI]
    alias profile_image_url profile_image_uri

    # Returns the secure URL to the user's profile image
    #
    # @api public
    # @example
    #   user.profile_image_uri_https(:normal)
    # @param size [String, Symbol] The size of the image
    # @return [Addressable::URI]
    def profile_image_uri_https(size = :normal)
      # The profile image URL comes in looking like like this:
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png
      # It can be converted to any of the following sizes:
      # https://a0.twimg.com/profile_images/1759857427/image1326743606.png
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png
      # https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png
      parse_uri(@attrs[:profile_image_url_https].sub(PROFILE_IMAGE_SUFFIX_REGEX, profile_image_suffix(size))) unless @attrs[:profile_image_url_https].nil? # steep:ignore FallbackAny
    end

    # @!method profile_image_url_https
    #   Returns the secure URL to the user's profile image
    #   @api public
    #   @example
    #     user.profile_image_url_https(:normal)
    #   @return [Addressable::URI]
    alias profile_image_url_https profile_image_uri_https

    # Returns true if the user has a profile image
    #
    # @api public
    # @example
    #   user.profile_image_uri?
    # @return [Boolean]
    def profile_image_uri?
      !!@attrs[:profile_image_url_https] # steep:ignore FallbackAny
    end
    memoize :profile_image_uri?
    alias profile_image_url? profile_image_uri?
    alias profile_image_uri_https? profile_image_uri?
    alias profile_image_url_https? profile_image_uri?

  private

    # Parses a URI string
    #
    # @api private
    # @param uri [String] The URI string
    # @return [Addressable::URI]
    def parse_uri(uri)
      Addressable::URI.parse(uri)
    end

    # Converts a URI to insecure (http) version
    #
    # @api private
    # @param uri [Object] The URI to convert
    # @return [String]
    def insecure_uri(uri)
      uri.to_s.sub(/\Ahttps/i, "http")
    end

    # Returns the suffix for profile image URLs
    #
    # @api private
    # @param size [Symbol] The size
    # @return [String]
    def profile_image_suffix(size)
      size.to_sym == :original ? '\\1' : "_#{size}\\1"
    end
  end
end
