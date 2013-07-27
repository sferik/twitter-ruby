require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class DirectMessage < Twitter::Identity
    include Twitter::Creatable
    attr_reader :text
    alias full_text text

    # @return [Twitter::User]
    def recipient
      new_or_null_object(Twitter::User, :recipient)
    end

    # @return [Twitter::User]
    def sender
      new_or_null_object(Twitter::User, :sender)
    end

  end
end
