require 'singleton'

module Twitter
  class NullObject < BasicObject
    include ::Singleton

    def nil?
      true
    end

    def method_missing(method_name, *args, &block)
      self
    end

    def respond_to_missing?(method_name, include_private=false)
      true
    end

  end
end
