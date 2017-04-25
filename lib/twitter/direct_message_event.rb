require 'twitter/creatable'
require 'twitter/entities'
require 'twitter/identity'

module Twitter
  class DirectMessageEvent < Twitter::Identity
    include Twitter::Creatable
    include Twitter::Entities

    attr_reader :created_timestamp

    object_attr_reader :DirectMessage, :direct_message

    def initialize(attrs)
      text = attrs[:message_create][:message_data][:text]
      urls = attrs[:message_create][:message_data][:entities][:urls]

      if urls.any?
        text.gsub!(
          urls[0][:url],
          urls[0][:expanded_url]
        )
      end

      attrs[:direct_message] = {
        id: attrs[:id].to_i,
        created_at: Time.at(attrs[:created_timestamp].to_i / 1000.0),
        sender: { id: attrs[:message_create][:sender_id].to_i },
        recipient: { id: attrs[:message_create][:target][:recipient_id].to_i },
        text: text
      }
      super
    end

  end
end

