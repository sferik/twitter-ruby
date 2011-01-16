# -*- encoding: utf-8 -*-
module Twitter
  class Client
    # @private
    module Utils
      private

      # Returns the configured screen name or the screen name of the authenticated user
      #
      # @return [String]
      def get_screen_name
        self.verify_credentials.screen_name
      end

      # Remove @ signs from screen names
      #
      # @param screen_name [String] A Twitter screen name.
      # @return [String] The Twitter screen name minus the @ sign.
      def clean_screen_name!(screen_name)
        screen_name.gsub!(/[@＠]/, '') if screen_name
      end

      # Take a single user ID or screen name and merge it into an options hash with the correct key
      #
      # @param user_id_or_screen_name [Integer, String] A Twitter user ID or screen_name.
      # @param options [Hash] A customizable set of options.
      # @return [Hash]
      def merge_user_into_options!(user_id_or_screen_name, options={})
        case user_id_or_screen_name
        when Fixnum
          options[:user_id] = user_id_or_screen_name
        when String
          clean_screen_name!(user_id_or_screen_name)
          options[:screen_name] = user_id_or_screen_name
        end
        options
      end

      # Take a multiple user IDs and screen names and merge them into an options hash with the correct keys
      #
      # @param users_id_or_screen_names [Array] An array of Twitter user IDs or screen_names.
      # @param options [Hash] A customizable set of options.
      # @return [Hash]
      def merge_users_into_options!(user_ids_or_screen_names, options={})
        user_ids, screen_names = [], []
        user_ids_or_screen_names.flatten.each do |user_id_or_screen_name|
          case user_id_or_screen_name
          when Fixnum
            user_ids << user_id_or_screen_name
          when String
            clean_screen_name!(user_id_or_screen_name)
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
