require 'equalizer'
require 'twitter/base'

module Twitter
  class Size < Twitter::Base
    include Equalizer.new(:h, :w)
    attr_reader :h, :resize, :w
    alias height h
    alias width w
  end
end
