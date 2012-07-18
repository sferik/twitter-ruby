module Twitter

  # Tracks objects to help ensure that each object gets loaded only once.
  # See: http://www.martinfowler.com/eaaCatalog/identityMap.html
  class IdentityMap < Hash

    # @param id
    # @return [Object]
    def fetch(id)
      self[id]
    end

    # @param id
    # @param object
    # @return [Object]
    def store(id, object)
      self[id] = object
    end

  end

  # Inherit from KeyError when Ruby 1.8 compatibility is removed
  class IdentityMapKeyError < ::IndexError
  end

end
