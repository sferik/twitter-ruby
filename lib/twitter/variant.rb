require "twitter/base"

module Twitter
  # Represents a video variant with a specific bitrate and format
  class Variant < Twitter::Base
    # The bitrate of this variant in bits per second
    #
    # @api public
    # @example
    #   variant.bitrate
    # @return [Integer]
    attr_reader :bitrate

    # The content type (MIME type) of this variant
    #
    # @api public
    # @example
    #   variant.content_type
    # @return [String]
    attr_reader :content_type

    uri_attr_reader :uri
  end
end
