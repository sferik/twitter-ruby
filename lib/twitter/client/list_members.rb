module Twitter
  class Client
    # Defines methods related to list members
    # @see Twitter::Client::List
    # @see Twitter::Client::ListSubscribers
    module ListMembers
      # Returns the members of the specified list
      #
      # @overload list_members(screen_name, list_id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array]
      #   @example Return the members of @sferik's "presidents" list
      #     Twitter.list_members("sferik", "presidents")
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @see http://dev.twitter.com/doc/get/:user/:list_id/members
      def list_members(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        list_id = args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        response = get("#{screen_name}/#{list_id}/members", options)
        format.to_s.downcase == 'xml' ? response['users_list'] : response
      end

      # Add a member to a list
      #
      # @overload list_add_member(screen_name, list_id, id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param id [Integer] The user id of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The list.
      #   @example Add @BarackObama to @sferik's "presidents" list
      #     Twitter.list_add_member("sferik", "presidents", 813286)
      # @note Lists are limited to having 500 members.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @see http://dev.twitter.com/doc/post/:user/:list_id/members
      def list_add_member(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id, list_id = args.pop, args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        response = post("#{screen_name}/#{list_id}/members", options.merge(:id => id))
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Adds multiple members to a list
      #
      # @overload list_add_members(screen_name, list_id, users, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param users [Array] The user ids to add.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The list.
      #   @example Add @BarackObama and @Jasonfinn to @sferik's "presidents" list
      #     Twitter.list_add_members("sferik", "presidents", [813286, 18755393])
      # @note Lists are limited to having 500 members, and you are limited to adding up to 100 members to a list at a time with this method.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @see http://dev.twitter.com/doc/post/:user/:list_id/create_all
      def list_add_members(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        users, list_id = args.pop, args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        merge_users_into_options!(Array(users), options)
        response = post("#{screen_name}/#{list_id}/create_all", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Removes the specified member from the list
      #
      # @overload list_remove_member(screen_name, list_id, id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param id [Integer] The user id of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The list.
      #   @example Remove @BarackObama from @sferik's "presidents" list
      #     Twitter.list_remove_member("sferik", "presidents", 813286)
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @see http://dev.twitter.com/doc/delete/:user/:list_id/members
      def list_remove_member(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id, list_id = args.pop, args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        response = delete("#{screen_name}/#{list_id}/members", options.merge(:id => id))
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Check if a user is a member of the specified list
      #
      # @overload is_list_member?(screen_name, list_id, id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param id [Integer] The user id of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a member of the specified list, otherwise false.
      #   @example Check if @BarackObama is a member of @sferik's "presidents" list
      #     Twitter.is_list_member?("sferik", "presidents", 813286)
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @see http://dev.twitter.com/doc/get/:user/:list_id/members/:id
      def is_list_member?(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id, list_id = args.pop, args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        begin
          get("#{screen_name}/#{list_id}/members/#{id}", options)
          true
        rescue Twitter::NotFound
          false
        end
      end
    end
  end
end
