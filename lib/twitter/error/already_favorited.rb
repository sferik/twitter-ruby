require 'twitter/error/forbidden'

module Twitter
  class Error
    # Raised when a Tweet has already been favorited
    class AlreadyFavorited < Twitter::Error::Forbidden
      MESSAGE = "You have already favorited this status"
    end
  end
end
