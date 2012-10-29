require 'twitter/error/forbidden'

module Twitter
  class Error
    # Raised when a Tweet has already been retweeted
    class AlreadyRetweeted < Twitter::Error::Forbidden
      MESSAGE = "sharing is not permissible for this status (Share validations failed)"
    end
  end
end
