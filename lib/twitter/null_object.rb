require 'singleton'

module Twitter
  class NullObject
    include Singleton

    def nil?
      true
    end

    def method_missing(*args, &block)
      nil
    end

    def respond_to_missing?(method_name, include_private=false)
      true
    end

  end
end
