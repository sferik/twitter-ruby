require 'singleton'

module Twitter
  class NullObject
    include Singleton

    def method_missing(*args, &block)
      nil
    end

    def null?
      true
    end
    alias nil? null?

  end
end
