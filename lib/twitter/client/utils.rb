module Twitter
  class Client
    # @private
    module Utils
      private

      def merge_user_into_options!(user_id_or_screen_name, options={})
        case user_id_or_screen_name
          when Fixnum, /^\d+$/
            options[:user_id] = user_id_or_screen_name.to_i
          when String
            options[:screen_name] = user_id_or_screen_name
        end
        options
      end

      def merge_users_into_options!(user_ids_or_screen_names, options={})
        user_ids, screen_names = [], []
        user_ids_or_screen_names.flatten.each do |user_id_or_screen_name|
          case user_id_or_screen_name
            when Fixnum, /^\d+$/
              user_ids << user_id_or_screen_name.to_i
            when String
              screen_names << user_id_or_screen_name
          end
        end
        options[:user_id] = user_ids.join(',') unless user_ids.empty?
        options[:screen_name] = screen_names.join(',') unless screen_names.empty?
        options
      end
    end
  end
end
