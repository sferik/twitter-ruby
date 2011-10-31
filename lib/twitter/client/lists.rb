require 'twitter/core_ext/hash'
require 'twitter/cursor'
require 'twitter/error/forbidden'
require 'twitter/error/not_found'
require 'twitter/list'
require 'twitter/status'
require 'twitter/user'

module Twitter
  class Client
    module Lists

      # Returns all lists the authenticating or specified user subscribes to, including their own
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/all
      # @rate_limited Yes
      # @requires_authentication Supported
      # @overload lists_subscribed_to(options={})
      #   @param options [Hash] A customizable set of options.
      #   @return [Array<Twitter::Status>]
      #   @example Return all lists the authenticating user subscribes to
      #     Twitter.lists_subscribed_to
      # @overload lists_subscribed_to(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @return [Array<Twitter::List>]
      #   @example Return all lists the specified user subscribes to
      #     Twitter.lists_subscribed_to("sferik")
      #     Twitter.lists_subscribed_to(8863586)
      def lists_subscribed_to(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if user = args.pop
          options.merge_user!(user)
        end
        get("/1/lists/all.json", options).map do |list|
          Twitter::List.new(list)
        end
      end

      # Show tweet timeline for members of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/statuses
      # @rate_limited Yes
      # @requires_authentication No
      # @overload list_timeline(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :per_page The number of results to retrieve.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array<Twitter::Status>]
      #   @example Show tweet timeline for members of the authenticated user's "presidents" list
      #     Twitter.list_timeline("presidents")
      #     Twitter.list_timeline(8863586)
      # @overload list_timeline(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :per_page The number of results to retrieve.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array<Twitter::Status>]
      #   @example Show tweet timeline for members of @sferik's "presidents" list
      #     Twitter.list_timeline("sferik", "presidents")
      #     Twitter.list_timeline("sferik", 8863586)
      #     Twitter.list_timeline(7505382, "presidents")
      #     Twitter.list_timeline(7505382, 8863586)
      def list_timeline(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        get("/1/lists/statuses.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Removes the specified member from the list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/members/destroy
      # @rate_limited No
      # @requires_authentication Yes
      # @overload list_remove_member(list, user_to_remove, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Remove @BarackObama from the authenticated user's "presidents" list
      #     Twitter.list_remove_member("presidents", 813286)
      #     Twitter.list_remove_member("presidents", 'BarackObama')
      #     Twitter.list_remove_member(8863586, 'BarackObama')
      # @overload list_remove_member(user, list, user_to_remove, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Remove @BarackObama from @sferik's "presidents" list
      #     Twitter.list_remove_member("sferik", "presidents", 813286)
      #     Twitter.list_remove_member("sferik", "presidents", 'BarackObama')
      #     Twitter.list_remove_member('sferik', 8863586, 'BarackObama')
      #     Twitter.list_remove_member(7505382, "presidents", 813286)
      def list_remove_member(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user_to_remove = args.pop
        options.merge_user!(user_to_remove)
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = post("/1/lists/members/destroy.json", options)
        Twitter::List.new(list)
      end

      # List the lists the specified user has been added to
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/memberships
      # @rate_limited Yes
      # @requires_authentication Supported
      # @overload memberships(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example List the lists the authenticated user has been added to
      #     Twitter.memberships
      # @overload memberships(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example List the lists that @sferik has been added to
      #     Twitter.memberships("sferik")
      #     Twitter.memberships(7505382)
      def memberships(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        if user = args.pop
          options.merge_user!(user)
        end
        cursor = get("/1/lists/memberships.json", options)
        Twitter::Cursor.new(cursor, 'lists', Twitter::List)
      end

      # Returns the subscribers of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers
      # @rate_limited Yes
      # @requires_authentication Supported
      # @overload list_subscribers(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Twitter::Cursor] The subscribers of the specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the subscribers of the authenticated user's "presidents" list
      #     Twitter.list_subscribers('presidents')
      #     Twitter.list_subscribers(8863586)
      # @overload list_subscribers(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Twitter::Cursor] The subscribers of the specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the subscribers of @sferik's "presidents" list
      #     Twitter.list_subscribers("sferik", 'presidents')
      #     Twitter.list_subscribers("sferik", 8863586)
      #     Twitter.list_subscribers(7505382, 'presidents')
      def list_subscribers(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        cursor = get("/1/lists/subscribers.json", options)
        Twitter::Cursor.new(cursor, 'users', Twitter::User)
      end

      # List the lists the specified user follows
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscriptions
      # @rate_limited Yes
      # @requires_authentication Supported
      # @overload subscriptions(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example List the lists the authenticated user follows
      #     Twitter.subscriptions
      # @overload subscriptions(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example List the lists that @sferik follows
      #     Twitter.subscriptions("sferik")
      #     Twitter.subscriptions(7505382)
      def subscriptions(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        if user = args.pop
          options.merge_user!(user)
        end
        cursor = get("/1/lists/subscriptions.json", options)
        Twitter::Cursor.new(cursor, 'lists', Twitter::List)
      end

      # Make the authenticated user follow the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/create
      # @rate_limited No
      # @requires_authentication Yes
      # @overload list_subscribe(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Subscribe to the authenticated user's "presidents" list
      #     Twitter.list_subscribe('presidents')
      #     Twitter.list_subscribe(8863586)
      # @overload list_subscribe(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Subscribe to @sferik's "presidents" list
      #     Twitter.list_subscribe("sferik", 'presidents')
      #     Twitter.list_subscribe("sferik", 8863586)
      #     Twitter.list_subscribe(7505382, 'presidents')
      def list_subscribe(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = post("/1/lists/subscribers/create.json", options)
        Twitter::List.new(list)
      end

      # Check if a user is a subscriber of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers/show
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload list_subscriber?(list, user_to_check, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_check [Integer, String] The user ID or screen_name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Check if @BarackObama is a subscriber of the authenticated user's "presidents" list
      #     Twitter.list_subscriber?('presidents', 813286)
      #     Twitter.list_subscriber?(8863586, 813286)
      #     Twitter.list_subscriber?('presidents', 'BarackObama')
      # @overload list_subscriber?(user, list, user_to_check, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_check [Integer, String] The user ID or screen_name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
      #     Twitter.list_subscriber?("sferik", 'presidents', 813286)
      #     Twitter.list_subscriber?("sferik", 8863586, 813286)
      #     Twitter.list_subscriber?(7505382, 'presidents', 813286)
      #     Twitter.list_subscriber?("sferik", 'presidents', 'BarackObama')
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      def list_subscriber?(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user_to_check = args.pop
        options.merge_user!(user_to_check)
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        get("/1/lists/subscribers/show.json", options, :raw => true)
        true
      rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
        false
      end

      # Unsubscribes the authenticated user form the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/destroy
      # @rate_limited No
      # @requires_authentication Yes
      # @overload list_unsubscribe(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Unsubscribe from the authenticated user's "presidents" list
      #     Twitter.list_unsubscribe('presidents')
      #     Twitter.list_unsubscribe(8863586)
      # @overload list_unsubscribe(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Unsubscribe from @sferik's "presidents" list
      #     Twitter.list_unsubscribe("sferik", 'presidents')
      #     Twitter.list_unsubscribe("sferik", 8863586)
      #     Twitter.list_unsubscribe(7505382, 'presidents')
      def list_unsubscribe(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = post("/1/lists/subscribers/destroy.json", options)
        Twitter::List.new(list)
      end

      # Adds multiple members to a list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/members/create_all
      # @note Lists are limited to having 500 members, and you are limited to adding up to 100 members to a list at a time with this method.
      # @rate_limited No
      # @requires_authentication Yes
      # @overload list_add_members(list, users_to_add, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param users_to_add [Array] The user IDs and/or screen names to add.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Add @BarackObama and @pengwynn to the authenticated user's "presidents" list
      #     Twitter.list_add_members("presidents", [813286, 18755393])
      #     Twitter.list_add_members('presidents', [813286, 'pengwynn'])
      #     Twitter.list_add_members(8863586, [813286, 18755393])
      # @overload list_add_members(user, list, users_to_add, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param users_to_add [Array] The user IDs and/or screen names to add.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Add @BarackObama and @pengwynn to @sferik's "presidents" list
      #     Twitter.list_add_members("sferik", "presidents", [813286, 18755393])
      #     Twitter.list_add_members('sferik', 'presidents', [813286, 'pengwynn'])
      #     Twitter.list_add_members('sferik', 8863586, [813286, 18755393])
      #     Twitter.list_add_members(7505382, "presidents", [813286, 18755393])
      #     Twitter.list_add_members(7505382, 8863586, [813286, 18755393])
      def list_add_members(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        users_to_add = args.pop
        options.merge_users!(Array(users_to_add))
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = post("/1/lists/members/create_all.json", options)
        Twitter::List.new(list)
      end

      # Check if a user is a member of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/members/show
      # @requires_authentication Yes
      # @rate_limited Yes
      # @overload list_member?(list, user_to_check, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a member of the specified list, otherwise false.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Check if @BarackObama is a member of the authenticated user's "presidents" list
      #     Twitter.list_member?("presidents", 813286)
      #     Twitter.list_member?(8863586, 'BarackObama')
      # @overload list_member?(user, list, user_to_check, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a member of the specified list, otherwise false.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Check if @BarackObama is a member of @sferik's "presidents" list
      #     Twitter.list_member?("sferik", "presidents", 813286)
      #     Twitter.list_member?('sferik', 8863586, 'BarackObama')
      #     Twitter.list_member?(7505382, "presidents", 813286)
      def list_member?(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user_to_check = args.pop
        options.merge_user!(user_to_check)
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        get("/1/lists/members/show.json", options, :raw => true)
        true
      rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
        false
      end

      # Returns the members of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/members
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload list_members(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the members of the authenticated user's "presidents" list
      #     Twitter.list_members("presidents")
      #     Twitter.list_members(8863586)
      # @overload list_members(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the members of @sferik's "presidents" list
      #     Twitter.list_members("sferik", "presidents")
      #     Twitter.list_members("sferik", 8863586)
      #     Twitter.list_members(7505382, "presidents")
      #     Twitter.list_members(7505382, 8863586)
      def list_members(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        cursor = get("/1/lists/members.json", options)
        Twitter::Cursor.new(cursor, 'users', Twitter::User)
      end

      # Add a member to a list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/members/create
      # @note Lists are limited to having 500 members.
      # @rate_limited No
      # @requires_authentication Yes
      # @overload list_add_member(list, user_to_add, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Add @BarackObama to the authenticated user's "presidents" list
      #     Twitter.list_add_member("presidents", 813286)
      #     Twitter.list_add_member(8863586, 813286)
      # @overload list_add_member(user, list, user_to_add, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Add @BarackObama to @sferik's "presidents" list
      #     Twitter.list_add_member("sferik", "presidents", 813286)
      #     Twitter.list_add_member('sferik', 8863586, 813286)
      #     Twitter.list_add_member(7505382, "presidents", 813286)
      #     Twitter.list_add_member(7505382, 8863586, 813286)
      def list_add_member(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user_to_add = args.pop
        options.merge_user!(user_to_add)
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = post("/1/lists/members/create.json", options)
        Twitter::List.new(list)
      end

      # Deletes the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/destroy
      # @note Must be owned by the authenticated user.
      # @rate_limited No
      # @requires_authentication Yes
      # @overload list_destroy(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The deleted list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Delete the authenticated user's "presidents" list
      #     Twitter.list_destroy("/presidents")
      #     Twitter.list_destroy(8863586)
      # @overload list_destroy(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The deleted list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Delete @sferik's "presidents" list
      #     Twitter.list_destroy("/sferik", "presidents")
      #     Twitter.list_destroy("/sferik", 8863586)
      #     Twitter.list_destroy(7505382, "presidents")
      #     Twitter.list_destroy(7505382, 8863586)
      def list_destroy(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = delete("/1/lists/destroy.json", options)
        Twitter::List.new(list)
      end

      # Updates the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/update
      # @rate_limited No
      # @requires_authentication Yes
      # @overload list_update(list, options={})
      #   @param list [Integer, String] The list_id or slug for the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      #   @option options [String] :description The description to give the list.
      #   @return [Twitter::List] The created list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Update the authenticated user's "presidents" list to have the description "Presidents of the United States of America"
      #     Twitter.list_update("presidents", :description => "Presidents of the United States of America")
      #     Twitter.list_update(8863586, :description => "Presidents of the United States of America")
      # @overload list_update(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug for the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      #   @option options [String] :description The description to give the list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @return [Twitter::List] The created list.
      #   @example Update the @sferik's "presidents" list to have the description "Presidents of the United States of America"
      #     Twitter.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
      #     Twitter.list_update(7505382, "presidents", :description => "Presidents of the United States of America")
      #     Twitter.list_update("sferik", 8863586, :description => "Presidents of the United States of America")
      #     Twitter.list_update(7505382, 8863586, :description => "Presidents of the United States of America")
      def list_update(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = post("/1/lists/update.json", options)
        Twitter::List.new(list)
      end

      # Creates a new list for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/create
      # @note Accounts are limited to 20 lists.
      # @rate_limited No
      # @requires_authentication Yes
      # @param name [String] The name for the list.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      # @option options [String] :description The description to give the list.
      # @return [Twitter::List] The created list.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Create a list named "presidents"
      #   Twitter.list_create("presidents")
      def list_create(name, options={})
        list = post("/1/lists/create.json", options.merge(:name => name))
        Twitter::List.new(list)
      end

      # List the lists of the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists
      # @note Private lists will be included if the authenticated user is the same as the user whose lists are being returned.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload lists(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example List the authenticated user's lists
      #     Twitter.lists
      # @overload lists(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example List @sferik's lists
      #     Twitter.lists("sferik")
      #     Twitter.lists(7505382)
      def lists(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        user = args.first
        options.merge_user!(user) if user
        cursor = get("/1/lists.json", options)
        Twitter::Cursor.new(cursor, 'lists', Twitter::List)
      end

      # Show the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/show
      # @note Private lists will only be shown if the authenticated user owns the specified list.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload list(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Show the authenticated user's "presidents" list
      #     Twitter.list("presidents")
      #     Twitter.list(8863586)
      # @overload list(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The specified list.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Show @sferik's "presidents" list
      #     Twitter.list("sferik", "presidents")
      #     Twitter.list("sferik", 8863586)
      #     Twitter.list(7505382, "presidents")
      #     Twitter.list(7505382, 8863586)
      def list(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        options.merge_list!(list)
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
        list = get("/1/lists/show.json", options)
        Twitter::List.new(list)
      end

    end
  end
end
