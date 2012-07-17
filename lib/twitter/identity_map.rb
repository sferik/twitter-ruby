module Twitter

  # Tracks objects to help ensure that each object gets loaded only once.
  # See: http://www.martinfowler.com/eaaCatalog/identityMap.html
  class IdentityMap < Hash

    # @param klass
    # @param key
    # @return [Object]
    def fetch(klass, key)
      self[klass] && self[klass][key]
    end

    # @param key
    # @param object
    # @return [Object]
    def store(key, object)
      self[object.class] ||= {}
      self[object.class][key] = object
    end

  end

  # Inherit from KeyError when Ruby 1.8 compatibility is removed
  class IdentityMapKeyError < ::IndexError
  end

end
