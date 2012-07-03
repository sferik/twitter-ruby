require 'twitter/creatable'
require 'twitter/identity'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Identity
    include Twitter::Creatable
    attr_reader :text

    # @return [Twitter::User]
    def recipient
      @recipient ||= Twitter::User.fetch_or_new(@attrs[:recipient]) unless @attrs[:recipient].nil?
    end

    # @return [Twitter::User]
    def sender
      @sender ||= Twitter::User.fetch_or_new(@attrs[:sender]) unless @attrs[:sender].nil?
    end

  end
end
