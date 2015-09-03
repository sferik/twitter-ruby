require 'naught'

module Twitter
  NullObject = Naught.build do |config|
    include Comparable

    config.black_hole
    config.define_explicit_conversions
    config.define_implicit_conversions
    config.predicates_return false
    
    def to_hash
      {}
    end

    def !
      true
    end

    def respond_to?(*)
      true
    end

    def instance_of?(klass)
      fail(TypeError, 'class or module required') unless klass.is_a?(Class)
      self.class == klass
    end

    def kind_of?(mod)
      fail(TypeError, 'class or module required') unless mod.is_a?(Module)
      self.class.ancestors.include?(mod)
    end

    alias_method :is_a?, :kind_of?

    def <=>(other)
      if other.is_a?(self.class)
        0
      else
        -1
      end
    end

    def nil?
      true
    end

    def as_json(*)
      'null'
    end
  end
end
