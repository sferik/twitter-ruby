module Twitter

  # Tracks objects to help ensure that each object gets loaded only once.
  # See: http://www.martinfowler.com/eaaCatalog/identityMap.html
  class IdentityMap < Hash
  end

  # Inherit from KeyError when Ruby 1.8 compatibility is removed
  class IdentityMapKeyError < ::IndexError
  end

end
