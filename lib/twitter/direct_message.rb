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
      @recipient ||= Twitter::User.new(@attrs['recipient']) unless @attrs['recipient'].nil?
    end

    # @return [Twitter::User]
    def sender
      @sender ||= Twitter::User.new(@attrs['sender']) unless @attrs['sender'].nil?
    end

  end
end
