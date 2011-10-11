require 'twitter/base'
require 'twitter/creatable'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Base
    include Twitter::Creatable
    attr_reader :id, :recipient_id, :recipient_screen_name, :sender_id,
      :sender_screen_name, :text

    def ==(other)
      super || id == other.id
    end

    def recipient
      Twitter::User.new(@recipient) if @recipient
    end

    def sender
      Twitter::User.new(@sender) if @sender
    end
  end
end
