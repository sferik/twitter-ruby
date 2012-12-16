require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class DirectMessage < Twitter::Identity
    include Twitter::Creatable
    attr_reader :text
    alias full_text text

    # @return [Twitter::User]
    def recipient
      @recipient ||= Twitter::User.fetch_or_new(@attrs[:recipient])
    end

    # @return [Twitter::User]
    def sender
      @sender ||= Twitter::User.fetch_or_new(@attrs[:sender])
    end

  end
end
