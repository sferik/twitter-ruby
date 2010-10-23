module Twitter
  class Client
    module Block
      def block(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        response = post('blocks/create', options)
        format.to_s.downcase == 'xml' ? response.user : response
      end

      def unblock(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        response = delete('blocks/destroy', options)
        format.to_s.downcase == 'xml' ? response.user : response
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
        response = get('blocks/blocking', options)
        format.to_s.downcase == 'xml' ? response.users : response
      end

      def blocked_ids(options={})
        authenticate!
        response = get('blocks/blocking/ids', options)
        format.to_s.downcase == 'xml' ? response.ids.id.map{|id| id.to_i} : response
      end
    end
  end
end
