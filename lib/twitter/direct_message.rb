require 'twitter/base'
require 'twitter/creatable'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Base
    include Twitter::Creatable
    attr_reader :recipient, :sender
    lazy_attr_reader :id, :text

    def initialize(attributes={})
      attributes = attributes.dup
      @recipient = Twitter::User.new(attributes.delete('recipient')) unless attributes['recipient'].nil?
      @sender = Twitter::User.new(attributes.delete('sender')) unless attributes['sender'].nil?
      super(attributes)
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
