module Twitter
  class Client
    module ListMembers
      def list_members(screen_name, slug, options={})
        get("#{screen_name}/#{slug}/members", options)
      end

      def list_add_member(screen_name, slug, user_id, options={})
        post("#{screen_name}/#{slug}/members", options.merge(:id => user_id))
      end

      def list_add_members(screen_name, slug, users, options={})
        merge_users_into_options!(Array(users), options)
        post("#{screen_name}/#{slug}/create_all", options)
      end

      def list_remove_member(screen_name, slug, user_id, options={})
        delete("#{screen_name}/#{slug}/members", options.merge(:id => user_id))
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
