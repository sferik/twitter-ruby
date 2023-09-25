require "X/creatable"
require "X/entities"
require "X/identity"

module X
  module DirectMessages
    class WelcomeMessage < X::Identity
      include X::Creatable
      include X::Entities
      # @return [String]
      attr_reader :text
      # @return [String]
      attr_reader :name
      alias full_text text
    end
  end
end
