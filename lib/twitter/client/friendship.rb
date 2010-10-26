module Twitter
  class Client
    module Friendship
      def follow(user, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        merge_user_into_options!(user, options)
        follow = args.first || false
        response = post('friendships/create', options.merge(:follow => follow))
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      alias :friendship_create :follow

      def unfollow(user, options={})
        merge_user_into_options!(user, options)
        response = delete('friendships/destroy', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      alias :friendship_destroy :unfollow

      def friendship_exists?(source, target, options={})
        response = get('friendships/exists', options.merge(:user_a => source, :user_b => target))
        format.to_s.downcase == 'xml' ? !%w(0 false).include?(response['friends']) : response
      end

      def friendship(options={})
        get('friendships/show', options)['relationship']
      end

      alias :friendship_show :friendship

      def friendships_incoming(options={})
        response = get('friendships/incoming', options)
        format.to_s.downcase == 'xml' ? response['id_list']['ids']['id'].map{|id| id.to_i} : response['ids']
      end

      def friendships_outgoing(options={})
        response = get('friendships/outgoing', options)
        format.to_s.downcase == 'xml' ? response['id_list']['ids']['id'].map{|id| id.to_i} : response['ids']
      end
    end
  end
end
