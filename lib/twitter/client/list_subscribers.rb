module Twitter
  class Client
    module ListSubscribers
      def list_subscribers(screen_name, slug, options={})
        response = get("#{screen_name}/#{slug}/subscribers", options)
        format.to_s.downcase == 'xml' ? response.users_list : response
      end

      def list_subscribe(screen_name, slug, options={})
        response = post("#{screen_name}/#{slug}/subscribers", options)
        format.to_s.downcase == 'xml' ? response.list : response
      end

      def list_unsubscribe(screen_name, slug, options={})
        response = delete("#{screen_name}/#{slug}/subscribers", options)
        format.to_s.downcase == 'xml' ? response.list : response
      end

      def is_subscriber?(screen_name, slug, user_id, options={})
        begin
          get("#{screen_name}/#{slug}/subscribers/#{user_id}", options)
          true
        rescue Twitter::NotFound
          false
        end
      end
    end
  end
end
