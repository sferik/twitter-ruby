require 'twitter/error'

module Twitter
  class Error
    # Raised when JSON parsing fails
    class DecodeError < Twitter::Error
    end
  end
end
