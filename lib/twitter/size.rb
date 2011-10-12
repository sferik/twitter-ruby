require 'twitter/base'

module Twitter
  class Size < Twitter::Base
    attr_reader :h, :resize, :w

    def ==(other)
      super || (other.class == self.class && other.height == self.height && other.width == self.width)
    end

    alias :height :h
    alias :width :w
  end
end
