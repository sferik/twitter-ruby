module Twitter
  class Client
    module DirectMessages
      def direct_messages(options={})
        response = get('direct_messages', options)
        format.to_s.downcase == 'xml' ? response['direct_messages'] : response
      end

      def direct_messages_sent(options={})
        response = get('direct_messages/sent', options)
        format.to_s.downcase == 'xml' ? response['direct_messages'] : response
      end

      def direct_message_create(user, text, options={})
        merge_user_into_options!(user, options)
        response = post('direct_messages/new', options.merge(:text => text))
        format.to_s.downcase == 'xml' ? response['direct_message'] : response
      end

      def direct_message_destroy(id, options={})
        response = delete("direct_messages/destroy/#{id}", options)
        format.to_s.downcase == 'xml' ? response['direct_message'] : response
      end
    end
  end
end
