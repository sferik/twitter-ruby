require 'twitter/base'

module Twitter
  class Size < Twitter::Base
    lazy_attr_reader :h, :resize, :w
    alias :height :h
    alias :width :w

    # @param other [Twiter::Size]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.h == self.h && other.w == self.w)
    end

  end
end
