require 'singleton'

module Twitter
  class NullObject
    include Singleton

    def nil?
      true
    end

    def method_missing(*args, &block)
      self
    end

    def respond_to?(method_name, include_private=false)
      true
    end if RUBY_VERSION < "1.9"

    def respond_to_missing?(method_name, include_private=false)
      true
    end if RUBY_VERSION >= "1.9"

  end
end
