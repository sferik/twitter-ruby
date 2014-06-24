require 'twitter/creatable'
require 'twitter/entities'
require 'twitter/identity'

module Twitter
  class DirectMessage < Twitter::Identity
    include Twitter::Creatable
    include Twitter::Entities
    # @return [String]
    attr_reader :text
    alias_method :full_text, :text
    object_attr_reader :User, :recipient
    object_attr_reader :User, :sender
  end
end
