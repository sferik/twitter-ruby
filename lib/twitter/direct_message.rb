require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class DirectMessage < Twitter::Identity
    include Twitter::Creatable
    attr_reader :text
    alias full_text text

    # @return [Twitter::User]
    def recipient
      @recipient ||= Twitter::User.new(@attrs[:recipient]) unless @attrs[:recipient].nil?
    end

    # @return [Twitter::User]
    def sender
      @sender ||= Twitter::User.new(@attrs[:sender]) unless @attrs[:sender].nil?
    end

  end
end
