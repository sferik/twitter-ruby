module Twitter
  class Client
    module ListMembers
      def list_members(screen_name, slug, options={})
        response = get("#{screen_name}/#{slug}/members", options)
        format.to_s.downcase == 'xml' ? response['users_list'] : response
      end

      def list_add_member(screen_name, slug, user_id, options={})
        response = post("#{screen_name}/#{slug}/members", options.merge(:id => user_id))
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      def list_add_members(screen_name, slug, users, options={})
        merge_users_into_options!(Array(users), options)
        response = post("#{screen_name}/#{slug}/create_all", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      def list_remove_member(screen_name, slug, user_id, options={})
        response = delete("#{screen_name}/#{slug}/members", options.merge(:id => user_id))
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      def is_list_member?(screen_name, slug, user_id, options={})
        begin
          get("#{screen_name}/#{slug}/members/#{user_id}", options)
          true
        rescue Twitter::NotFound
          false
        end
      end
    end
  end
end
