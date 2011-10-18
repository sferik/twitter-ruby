require 'twitter/base'
require 'twitter/creatable'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Base
    include Twitter::Creatable
    attr_reader :id, :recipient, :sender, :text

    def initialize(direct_message={})
      @created_at = direct_message['created_at']
      @id = direct_message['id']
      @recipient = Twitter::User.new(direct_message['recipient']) unless direct_message['recipient'].nil?
      @sender = Twitter::User.new(direct_message['sender']) unless direct_message['sender'].nil?
      @text = direct_message['text']
    end

    def ==(other)
      super || (other.class == self.class && other.id == @id)
    end

  end
end
