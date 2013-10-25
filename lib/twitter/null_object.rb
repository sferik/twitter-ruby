module Twitter
  class NullObject

    # @return [TrueClass] This method always returns true.
    def nil?
      true
    end

    # @return [Twitter::NullObject] This method always returns self.
    def method_missing(*args, &block)
      self
    end

    # @return [TrueClass] This method always returns true.
    def respond_to?(method_name, include_private=false)
      true
    end if RUBY_VERSION < "1.9"

    # @return [TrueClass] This method always returns true.
    def respond_to_missing?(method_name, include_private=false)
      true
    end if RUBY_VERSION >= "1.9"

  end
end
