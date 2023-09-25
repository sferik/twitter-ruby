require "X/creatable"
require "X/entities"
require "X/identity"

module X
  class DirectMessage < X::Identity
    include X::Creatable
    include X::Entities
    # @return [String]
    attr_reader :text
    attr_reader :sender_id, :recipient_id
    alias full_text text
    object_attr_reader :User, :recipient
    object_attr_reader :User, :sender
  end
end
