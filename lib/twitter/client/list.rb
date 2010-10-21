module Twitter
  class Client
    module List
      def list_create(screen_name, name, options={})
        post("#{screen_name}/lists", options.merge(:name => name))
      end

      def list_update(screen_name, name, options={})
        put("#{screen_name}/lists/#{name}", options)
      end

      def lists(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        screen_name = args.first
        if screen_name
          get("#{screen_name}/lists", options)
        else
          authenticate! do
            get('lists', options)
          end
        end
      end

      def list(screen_name, name, options={})
        get("#{screen_name}/lists/#{name}", options)
      end

      def list_delete(screen_name, name, options={})
        delete("#{screen_name}/lists/#{name}", options)
      end

      def list_timeline(screen_name, name, options={})
        get("#{screen_name}/lists/#{name}/statuses", options)
      end

      def memberships(screen_name, options={})
        authenticate! do
          get("#{screen_name}/lists/memberships", options)
        end
      end

      def subscriptions(screen_name, options={})
        authenticate! do
          get("#{screen_name}/lists/subscriptions", options)
        end
      end
    end
  end
end
