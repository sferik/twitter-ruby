module Twitter
  class Client
    module ListSubscribers
      def list_subscribers(screen_name, slug, options={})
        get("#{screen_name}/#{slug}/subscribers", options)
      end

      def list_subscribe(screen_name, slug, options={})
        authenticate! do
          post("#{screen_name}/#{slug}/subscribers", options)
        end
      end

      def list_unsubscribe(screen_name, slug, options={})
        authenticate! do
          delete("#{screen_name}/#{slug}/subscribers", options)
        end
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
