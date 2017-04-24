require 'twitter/creatable'
require 'twitter/entities'
require 'twitter/identity'

module Twitter
  class DirectMessageEvent < Twitter::Identity
    include Twitter::Creatable
    include Twitter::Entities
    # @return [String]
    attr_reader :created_timestamp
    attr_reader :recipient_id
    attr_reader :sender_id
    attr_reader :text
  end
end

