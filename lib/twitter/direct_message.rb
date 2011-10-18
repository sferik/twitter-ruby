require 'twitter/base'
require 'twitter/creatable'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Base
    include Twitter::Creatable
    attr_reader :id, :recipient, :sender, :text

    def initialize(direct_message={})
      @recipient = Twitter::User.new(direct_message.delete('recipient')) unless direct_message['recipient'].nil?
      @sender = Twitter::User.new(direct_message.delete('sender')) unless direct_message['sender'].nil?
      super(direct_message)
    end

    def ==(other)
      super || (other.class == self.class && other.instance_variable_get('@id'.to_sym) == @id)
    end

  end
end
