require 'equalizer'
require 'twitter/base'

module Twitter
  class Size < Twitter::Base
    include Equalizer.new(:h, :w)
    attr_reader :h, :resize, :w
    alias_method :height, :h
    alias_method :width, :w
  end
end
