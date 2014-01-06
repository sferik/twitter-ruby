require 'forwardable'

module Twitter
  class NullObject
    extend Forwardable
    def_instance_delegators :nil, :nil?, :to_a, :to_c, :to_c, :to_f, :to_h,
                            :to_i, :to_r, :to_s
    alias_method :to_ary, :to_a
    alias_method :to_str, :to_s

    # @return [Twitter::NullObject] This method always returns self.
    def method_missing(*args, &block)
      self
    end

    # @return [TrueClass] This method always returns true.
    def respond_to?(method_name, include_private = false)
      true
    end if RUBY_VERSION < '1.9'

    # @return [TrueClass] This method always returns true.
    def respond_to_missing?(method_name, include_private = false)
      true
    end if RUBY_VERSION >= '1.9'
  end
end
