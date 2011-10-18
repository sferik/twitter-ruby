require 'twitter/base'
require 'twitter/creatable'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Base
    include Twitter::Creatable
    lazy_attr_reader :id, :text

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def recipient
      @recipient ||= Twitter::User.new(@attributes['recipient']) unless @attributes['recipient'].nil?
    end

    def sender
      @sender ||= Twitter::User.new(@attributes['sender']) unless @attributes['sender'].nil?
    end

  end
end
