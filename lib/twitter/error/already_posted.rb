require 'twitter/error/forbidden'

module Twitter
  class Error
    # Raised when a Tweet has already been posted
    class AlreadyPosted < Twitter::Error
      MESSAGE = "Status is a duplicate"
    end
  end
end
