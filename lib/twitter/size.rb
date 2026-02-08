require "equalizer"
require "twitter/base"

module Twitter
  # Represents a size for media objects
  class Size < Base
    include Equalizer.new(:h, :w)

    # The height in pixels
    #
    # @api public
    # @example
    #   size.h
    # @return [Integer]

    # The width in pixels
    #
    # @api public
    # @example
    #   size.w
    # @return [Integer]
    attr_reader :h, :w

    # The resize method used
    #
    # @api public
    # @example
    #   size.resize
    # @return [String]
    attr_reader :resize

    # @!method height
    #   The height in pixels
    #   @api public
    #   @example
    #     size.height
    #   @return [Integer]
    alias_method :height, :h

    # @!method width
    #   The width in pixels
    #   @api public
    #   @example
    #     size.width
    #   @return [Integer]
    alias_method :width, :w
  end
end
