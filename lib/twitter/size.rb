require 'twitter/base'

module Twitter
  class Size < Twitter::Base
    attr_reader :h, :resize, :w
    alias height h
    alias width w

    # @param other [Twitter::Size]
    # @return [Boolean]
    def ==(other)
      super || self.size_equal(other) || self.attrs_equal(other)
    end

  protected

    # @param other [Twitter::Size]
    # @return [Boolean]
    def size_equal(other)
      self.class == other.class && !other.h.nil? && self.h == other.h && !other.w.nil? && self.w == other.w
    end

  end
end
