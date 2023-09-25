require "X/creatable"
require "X/identity"

module X
  module DirectMessages
    class WelcomeMessageRule < X::Identity
      include X::Creatable
      # @return [Integer]
      attr_reader :welcome_message_id
    end
  end
end
