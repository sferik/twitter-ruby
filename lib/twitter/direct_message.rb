require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class DirectMessage < Twitter::Identity
    include Twitter::Creatable
    attr_reader :text
    alias full_text text

    # @return [Twitter::User, Twitter::NullObject]
    def recipient
      new_or_null_object(Twitter::User, :recipient)
    end

    # @return [Boolean]
    def recipient?
      !recipient.nil?
    end

    # @return [Twitter::User, Twitter::NullObject]
    def sender
      new_or_null_object(Twitter::User, :sender)
    end

    # @return [Boolean]
    def sender?
      !sender.nil?
    end

  end
end
