require "equalizer"
require "X/base"

module X
  class Geo < X::Base
    include Equalizer.new(:coordinates)
    # @return [Array<Float>]
    attr_reader :coordinates
    alias coords coordinates
  end
end
