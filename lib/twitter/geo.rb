require "equalizer"
require "twitter/base"

module Twitter
  # Represents geographic information
  class Geo < Base
    include Equalizer.new(:coordinates)

    # The coordinates of this geographic location
    #
    # @api public
    # @example
    #   geo.coordinates
    # @return [Array<Float>]
    attr_reader :coordinates

    # @!method coords
    #   The coordinates of this geographic location
    #   @api public
    #   @example
    #     geo.coords
    #   @return [Array<Float>]
    alias coords coordinates
  end
end
