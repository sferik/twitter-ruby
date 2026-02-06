require "twitter/base"

module Twitter
  # Represents oEmbed data for a Tweet
  class OEmbed < Twitter::Base
    # The height of the embedded content
    #
    # @api public
    # @example
    #   oembed.height
    # @return [Integer]

    # The width of the embedded content
    #
    # @api public
    # @example
    #   oembed.width
    # @return [Integer]
    attr_reader :height, :width

    # The author name
    #
    # @api public
    # @example
    #   oembed.author_name
    # @return [String]

    # The cache age in seconds
    #
    # @api public
    # @example
    #   oembed.cache_age
    # @return [String]

    # The HTML to embed the Tweet
    #
    # @api public
    # @example
    #   oembed.html
    # @return [String]

    # The provider name
    #
    # @api public
    # @example
    #   oembed.provider_name
    # @return [String]

    # The oEmbed type
    #
    # @api public
    # @example
    #   oembed.type
    # @return [String]

    # The oEmbed version
    #
    # @api public
    # @example
    #   oembed.version
    # @return [String]
    attr_reader :author_name, :cache_age, :html, :provider_name, :type,
                :version

    uri_attr_reader :author_uri, :provider_uri, :uri
  end
end
