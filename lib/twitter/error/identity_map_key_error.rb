require 'twitter/error'

module Twitter
  class Error
    class IdentityMapKeyError < ::KeyError
    end
  end
end
