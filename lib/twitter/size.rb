require 'twitter/base'

module Twitter
  class Size < Twitter::Base
    attr_reader :h, :resize, :w
    alias :height :h
    alias :width :w

    def ==(other)
      super || (other.class == self.class && other.height == self.height && other.width == self.width)
    end

  end
end
