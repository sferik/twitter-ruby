require "twitter/identity"
require "twitter/utils"

module Twitter
  # Represents a basic Twitter user with minimal attributes
  class BasicUser < Twitter::Identity
    # The user's screen name (handle)
    #
    # @api public
    # @example
    #   user.screen_name # => "sferik"
    # @return [String]
    attr_reader :screen_name

    predicate_attr_reader :following
  end
end
