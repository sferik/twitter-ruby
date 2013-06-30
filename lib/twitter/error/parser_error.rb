require 'twitter/error'

module Twitter
  class Error
    # Raised when JSON parsing fails
    class ParserError < Twitter::Error
    end
  end
end
