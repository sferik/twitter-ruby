require "naught"

module Twitter
  # A null object that absorbs all method calls and returns itself
  # @see https://github.com/avdi/naught
  NullObject = Naught.build do |config| # steep:ignore # rubocop:disable Metrics/BlockLength
    include Comparable

    config.black_hole
    config.define_explicit_conversions
    config.define_implicit_conversions
    config.predicates_return false

    def ! # steep:ignore UndeclaredMethodDefinition
      true
    end

    def respond_to?(*_args) # steep:ignore DifferentMethodParameterKind
      true
    end

    def instance_of?(klass)
      Object.instance_method(:instance_of?).bind_call(self, klass)
    rescue TypeError
      false
    end

    def kind_of?(mod)
      raise(TypeError, "class or module required") unless mod.is_a?(Module)

      self.class.ancestors.include?(mod)
    end

    alias_method :is_a?, :kind_of?

    def <=>(other) # steep:ignore MethodBodyTypeMismatch
      if other.is_a?(self.class)
        0
      else
        -1
      end
    end

    def nil? # steep:ignore MethodBodyTypeMismatch
      true
    end

    def as_json(*) # steep:ignore UndeclaredMethodDefinition,FallbackAny
      "null"
    end

    def to_json(*) # steep:ignore UndeclaredMethodDefinition,FallbackAny
      nil.to_json(*) # steep:ignore NoMethod
    end

    def presence # steep:ignore UndeclaredMethodDefinition
      nil
    end

    def blank? # steep:ignore UndeclaredMethodDefinition
      true
    end

    def present? # steep:ignore UndeclaredMethodDefinition
      false
    end
  end
end
