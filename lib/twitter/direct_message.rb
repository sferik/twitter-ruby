require 'twitter/creatable'
require 'twitter/identifiable'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Identifiable
    include Twitter::Creatable
    attr_reader :text

    # @param other [Twitter::DirectMessage]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [Twitter::User]
    def recipient
      @recipient ||= Twitter::User.get_or_new(@attrs['recipient']) unless @attrs['recipient'].nil?
    end

    # @return [Twitter::User]
    def sender
      @sender ||= Twitter::User.get_or_new(@attrs['sender']) unless @attrs['sender'].nil?
    end

  end
end
