module Twitter
  class Client
    module Block
      def block(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        post('blocks/create', options)
      end

      def unblock(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        delete('blocks/destroy', options)
      end

      def block_exists?(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        begin
          get('blocks/exists', options)
          true
        rescue Twitter::NotFound
          false
        end
      end

      def blocking(options={})
        authenticate!
        get('blocks/blocking', options)
      end

      def blocked_ids(options={})
        authenticate!
        get('blocks/blocking/ids', options)
      end
    end
  end
end
