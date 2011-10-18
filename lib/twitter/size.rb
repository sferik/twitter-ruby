require 'twitter/base'

module Twitter
  class Size < Twitter::Base
    attr_reader :h, :resize, :w
    alias :height :h
    alias :width :w

    def ==(other)
      super || (other.class == self.class && other.instance_variable_get('@h'.to_sym) == @h && other.instance_variable_get('@w'.to_sym) == @w)
    end

  end
end
