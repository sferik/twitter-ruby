require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class DirectMessage < Twitter::Identity
    include Twitter::Creatable
    attr_reader :text
    alias full_text text
    object_attr_reader :User, :recipient
    object_attr_reader :User, :sender
  end
end
