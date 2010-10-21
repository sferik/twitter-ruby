module Twitter
  class Client
    module DirectMessages
      def direct_messages(options={})
        authenticate!
        get('direct_messages', options)
      end

      def direct_messages_sent(options={})
        authenticate!
        get('direct_messages/sent', options)
      end

      def direct_message_create(user, text, options={})
        authenticate!
        merge_user_into_options!(user, options)
        post('direct_messages/new', options.merge(:text => text))
      end

      def direct_message_destroy(id, options={})
        delete("direct_messages/destroy/#{id}", options)
      end
    end
  end
end
