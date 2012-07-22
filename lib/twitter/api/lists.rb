require 'twitter/api/utils'
require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/core_ext/hash'
require 'twitter/cursor'
require 'twitter/error/forbidden'
require 'twitter/error/not_found'
require 'twitter/list'
require 'twitter/user'

module Twitter
  module API
    module Lists
      include Twitter::API::Utils
      MAX_USERS_PER_REQUEST = 100

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :lists_subscribed_to => true,
            :list_timeline => true,
            :list_remove_member => false,
            :memberships => true,
            :list_subscribers => true,
            :subscriptions => true,
            :list_subscribe => false,
            :list_subscriber? => true,
            :list_unsubscribe => false,
            :list_add_members => false,
            :list_remove_members => false,
            :list_member? => true,
            :list_members => true,
            :list_add_member => false,
            :list_destroy => false,
            :list_update => false,
            :list_create => false,
            :lists => true,
            :list => true,
          }
        )
      end

      # Returns all lists the authenticating or specified user subscribes to, including their own
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/all
      # @rate_limited Yes
      # @authentication_required Supported
      # @return [Array<Twitter::List>]
      # @overload lists_subscribed_to(options={})
      #   @param options [Hash] A customizable set of options.
      #   @example Return all lists the authenticating user subscribes to
      #     Twitter.lists_subscribed_to
      # @overload lists_subscribed_to(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Return all lists the specified user subscribes to
      #     Twitter.lists_subscribed_to('sferik')
      #     Twitter.lists_subscribed_to(8863586)
      def lists_subscribed_to(*args)
        options = args.extract_options!
        if user = args.pop
          options.merge_user!(user)
        end
        response = get("/1/lists/all.json", options)
        collection_from_array(response[:body], Twitter::List)
      end

      # Show tweet timeline for members of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/statuses
      # @rate_limited Yes
      # @authentication_required No
      # @return [Array<Twitter::Status>]
      # @overload list_timeline(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :per_page The number of results to retrieve.
      #   @example Show tweet timeline for members of the authenticated user's "presidents" list
      #     Twitter.list_timeline('presidents')
      #     Twitter.list_timeline(8863586)
      # @overload list_timeline(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :per_page The number of results to retrieve.
      #   @example Show tweet timeline for members of @sferik's "presidents" list
      #     Twitter.list_timeline('sferik', 'presidents')
      #     Twitter.list_timeline('sferik', 8863586)
      #     Twitter.list_timeline(7505382, 'presidents')
      #     Twitter.list_timeline(7505382, 8863586)
      def list_timeline(*args)
        options = args.extract_options!
        list = args.pop
        options.merge_list!(list)
        unless options[:owner_id] || options[:owner_screen_name]
          owner = args.pop || self.verify_credentials.screen_name
          options.merge_owner!(owner)
        end
        response = get("/1/lists/statuses.json", options)
        collection_from_array(response[:body], Twitter::Status)
      end

      # Removes the specified member from the list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/members/destroy
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The list.
      # @overload list_remove_member(list, user_to_remove, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama from the authenticated user's "presidents" list
      #     Twitter.list_remove_member('presidents', 813286)
      #     Twitter.list_remove_member('presidents', 'BarackObama')
      #     Twitter.list_remove_member(8863586, 'BarackObama')
      # @overload list_remove_member(user, list, user_to_remove, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama from @sferik's "presidents" list
      #     Twitter.list_remove_member('sferik', 'presidents', 813286)
      #     Twitter.list_remove_member('sferik', 'presidents', 'BarackObama')
      #     Twitter.list_remove_member('sferik', 8863586, 'BarackObama')
      #     Twitter.list_remove_member(7505382, 'presidents', 813286)
      def list_remove_member(*args)
        list_modify_member(args) do |options|
          post("/1/lists/members/destroy.json", options)
        end
      end

      # List the lists the specified user has been added to
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/memberships
      # @rate_limited Yes
      # @authentication_required Supported
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload memberships(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List the lists the authenticated user has been added to
      #     Twitter.memberships
      # @overload memberships(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List the lists that @sferik has been added to
      #     Twitter.memberships('sferik')
      #     Twitter.memberships(7505382)
      def memberships(*args)
        options = {:cursor => -1}.merge(args.extract_options!)
        if user = args.pop
          options.merge_user!(user)
        end
        response = get("/1/lists/memberships.json", options)
        Twitter::Cursor.from_response(response, 'lists', Twitter::List)
      end

      # Returns the subscribers of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers
      # @rate_limited Yes
      # @authentication_required Supported
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor] The subscribers of the specified list.
      # @overload list_subscribers(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the subscribers of the authenticated user's "presidents" list
      #     Twitter.list_subscribers('presidents')
      #     Twitter.list_subscribers(8863586)
      # @overload list_subscribers(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the subscribers of @sferik's "presidents" list
      #     Twitter.list_subscribers('sferik', 'presidents')
      #     Twitter.list_subscribers('sferik', 8863586)
      #     Twitter.list_subscribers(7505382, 'presidents')
      def list_subscribers(*args)
        list_users(args) do |options|
          get("/1/lists/subscribers.json", options)
        end
      end

      # List the lists the specified user follows
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscriptions
      # @rate_limited Yes
      # @authentication_required Supported
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload subscriptions(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List the lists the authenticated user follows
      #     Twitter.subscriptions
      # @overload subscriptions(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List the lists that @sferik follows
      #     Twitter.subscriptions('sferik')
      #     Twitter.subscriptions(7505382)
      def subscriptions(*args)
        options = {:cursor => -1}.merge(args.extract_options!)
        if user = args.pop
          options.merge_user!(user)
        end
        response = get("/1/lists/subscriptions.json", options)
        Twitter::Cursor.from_response(response, 'lists', Twitter::List)
      end

      # Make the authenticated user follow the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/create
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The specified list.
      # @overload list_subscribe(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Subscribe to the authenticated user's "presidents" list
      #     Twitter.list_subscribe('presidents')
      #     Twitter.list_subscribe(8863586)
      # @overload list_subscribe(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Subscribe to @sferik's "presidents" list
      #     Twitter.list_subscribe('sferik', 'presidents')
      #     Twitter.list_subscribe('sferik', 8863586)
      #     Twitter.list_subscribe(7505382, 'presidents')
      def list_subscribe(*args)
        list_from_response(:post, "/1/lists/subscribers/create.json", args)
      end

      # Check if a user is a subscriber of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers/show
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      # @overload list_subscriber?(list, user_to_check, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a subscriber of the authenticated user's "presidents" list
      #     Twitter.list_subscriber?('presidents', 813286)
      #     Twitter.list_subscriber?(8863586, 813286)
      #     Twitter.list_subscriber?('presidents', 'BarackObama')
      # @overload list_subscriber?(user, list, user_to_check, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
      #     Twitter.list_subscriber?('sferik', 'presidents', 813286)
      #     Twitter.list_subscriber?('sferik', 8863586, 813286)
      #     Twitter.list_subscriber?(7505382, 'presidents', 813286)
      #     Twitter.list_subscriber?('sferik', 'presidents', 'BarackObama')
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      def list_subscriber?(*args)
        list_user?(args) do |options|
          get("/1/lists/subscribers/show.json", options)
        end
      end

      # Unsubscribes the authenticated user form the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/destroy
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The specified list.
      # @overload list_unsubscribe(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Unsubscribe from the authenticated user's "presidents" list
      #     Twitter.list_unsubscribe('presidents')
      #     Twitter.list_unsubscribe(8863586)
      # @overload list_unsubscribe(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Unsubscribe from @sferik's "presidents" list
      #     Twitter.list_unsubscribe('sferik', 'presidents')
      #     Twitter.list_unsubscribe('sferik', 8863586)
      #     Twitter.list_unsubscribe(7505382, 'presidents')
      def list_unsubscribe(*args)
        list_from_response(:post, "/1/lists/subscribers/destroy.json", args)
      end

      # Adds specified members to a list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/members/create_all
      # @note Lists are limited to having 500 members, and you are limited to adding up to 100 members to a list at a time with this method.
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The list.
      # @overload list_add_members(list, users, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama and @pengwynn to the authenticated user's "presidents" list
      #     Twitter.list_add_members('presidents', ['BarackObama', 'pengwynn'])
      #     Twitter.list_add_members('presidents', [813286, 18755393])
      #     Twitter.list_add_members(8863586, ['BarackObama', 'pengwynn'])
      #     Twitter.list_add_members(8863586, [813286, 18755393])
      # @overload list_add_members(user, list, users, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama and @pengwynn to @sferik's "presidents" list
      #     Twitter.list_add_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
      #     Twitter.list_add_members('sferik', 'presidents', [813286, 18755393])
      #     Twitter.list_add_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
      #     Twitter.list_add_members(7505382, 'presidents', [813286, 18755393])
      #     Twitter.list_add_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
      #     Twitter.list_add_members(7505382, 8863586, [813286, 18755393])
      def list_add_members(*args)
        list_modify_members(args) do |options|
          post("/1/lists/members/create_all.json", options)
        end
      end

      # Removes specified members from the list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/members/destroy_all
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The list.
      # @overload list_remove_members(list, users, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama and @pengwynn from the authenticated user's "presidents" list
      #     Twitter.list_remove_members('presidents', ['BarackObama', 'pengwynn'])
      #     Twitter.list_remove_members('presidents', [813286, 18755393])
      #     Twitter.list_remove_members(8863586, ['BarackObama', 'pengwynn'])
      #     Twitter.list_remove_members(8863586, [813286, 18755393])
      # @overload list_remove_members(user, list, users, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama and @pengwynn from @sferik's "presidents" list
      #     Twitter.list_remove_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
      #     Twitter.list_remove_members('sferik', 'presidents', [813286, 18755393])
      #     Twitter.list_remove_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
      #     Twitter.list_remove_members(7505382, 'presidents', [813286, 18755393])
      #     Twitter.list_remove_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
      #     Twitter.list_remove_members(7505382, 8863586, [813286, 18755393])
      def list_remove_members(*args)
        list_modify_members(args) do |options|
          post("/1/lists/members/destroy_all.json", options)
        end
      end

      # Check if a user is a member of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/members/show
      # @authentication_required Yes
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean] true if user is a member of the specified list, otherwise false.
      # @overload list_member?(list, user_to_check, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a member of the authenticated user's "presidents" list
      #     Twitter.list_member?('presidents', 813286)
      #     Twitter.list_member?(8863586, 'BarackObama')
      # @overload list_member?(user, list, user_to_check, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a member of @sferik's "presidents" list
      #     Twitter.list_member?('sferik', 'presidents', 813286)
      #     Twitter.list_member?('sferik', 8863586, 'BarackObama')
      #     Twitter.list_member?(7505382, 'presidents', 813286)
      def list_member?(*args)
        list_user?(args) do |options|
          get("/1/lists/members/show.json", options)
        end
      end

      # Returns the members of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/members
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload list_members(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the members of the authenticated user's "presidents" list
      #     Twitter.list_members('presidents')
      #     Twitter.list_members(8863586)
      # @overload list_members(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the members of @sferik's "presidents" list
      #     Twitter.list_members('sferik', 'presidents')
      #     Twitter.list_members('sferik', 8863586)
      #     Twitter.list_members(7505382, 'presidents')
      #     Twitter.list_members(7505382, 8863586)
      def list_members(*args)
        list_users(args) do |options|
          get("/1/lists/members.json", options)
        end
      end

      # Add a member to a list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/members/create
      # @note Lists are limited to having 500 members.
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The list.
      # @overload list_add_member(list, user_to_add, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama to the authenticated user's "presidents" list
      #     Twitter.list_add_member('presidents', 813286)
      #     Twitter.list_add_member(8863586, 813286)
      # @overload list_add_member(user, list, user_to_add, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama to @sferik's "presidents" list
      #     Twitter.list_add_member('sferik', 'presidents', 813286)
      #     Twitter.list_add_member('sferik', 8863586, 813286)
      #     Twitter.list_add_member(7505382, 'presidents', 813286)
      #     Twitter.list_add_member(7505382, 8863586, 813286)
      def list_add_member(*args)
        list_modify_member(args) do |options|
          post("/1/lists/members/create.json", options)
        end
      end

      # Deletes the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/destroy
      # @note Must be owned by the authenticated user.
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The deleted list.
      # @overload list_destroy(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Delete the authenticated user's "presidents" list
      #     Twitter.list_destroy('presidents')
      #     Twitter.list_destroy(8863586)
      # @overload list_destroy(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Delete @sferik's "presidents" list
      #     Twitter.list_destroy('sferik', 'presidents')
      #     Twitter.list_destroy('sferik', 8863586)
      #     Twitter.list_destroy(7505382, 'presidents')
      #     Twitter.list_destroy(7505382, 8863586)
      def list_destroy(*args)
        list_from_response(:delete, "/1/lists/destroy.json", args)
      end

      # Updates the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/update
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The created list.
      # @overload list_update(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      #   @option options [String] :description The description to give the list.
      #   @example Update the authenticated user's "presidents" list to have the description "Presidents of the United States of America"
      #     Twitter.list_update('presidents', :description => "Presidents of the United States of America")
      #     Twitter.list_update(8863586, :description => "Presidents of the United States of America")
      # @overload list_update(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      #   @option options [String] :description The description to give the list.
      #   @example Update the @sferik's "presidents" list to have the description "Presidents of the United States of America"
      #     Twitter.list_update('sferik', 'presidents', :description => "Presidents of the United States of America")
      #     Twitter.list_update(7505382, 'presidents', :description => "Presidents of the United States of America")
      #     Twitter.list_update('sferik', 8863586, :description => "Presidents of the United States of America")
      #     Twitter.list_update(7505382, 8863586, :description => "Presidents of the United States of America")
      def list_update(*args)
        list_from_response(:post, "/1/lists/update.json", args)
      end

      # Creates a new list for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/create
      # @note Accounts are limited to 20 lists.
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The created list.
      # @param name [String] The name for the list.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      # @option options [String] :description The description to give the list.
      # @example Create a list named 'presidents'
      #   Twitter.list_create('presidents')
      def list_create(name, options={})
        response = post("/1/lists/create.json", options.merge(:name => name))
        Twitter::List.from_response(response)
      end

      # List the lists of the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists
      # @note Private lists will be included if the authenticated user is the same as the user whose lists are being returned.
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload lists(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List the authenticated user's lists
      #     Twitter.lists
      # @overload lists(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List @sferik's lists
      #     Twitter.lists('sferik')
      #     Twitter.lists(7505382)
      def lists(*args)
        options = {:cursor => -1}.merge(args.extract_options!)
        user = args.pop
        options.merge_user!(user) if user
        response = get("/1/lists.json", options)
        Twitter::Cursor.from_response(response, 'lists', Twitter::List)
      end

      # Show the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/show
      # @note Private lists will only be shown if the authenticated user owns the specified list.
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::List] The specified list.
      # @overload list(list, options={})
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Show the authenticated user's "presidents" list
      #     Twitter.list('presidents')
      #     Twitter.list(8863586)
      # @overload list(user, list, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Show @sferik's "presidents" list
      #     Twitter.list('sferik', 'presidents')
      #     Twitter.list('sferik', 8863586)
      #     Twitter.list(7505382, 'presidents')
      #     Twitter.list(7505382, 8863586)
      def list(*args)
        list_from_response(:get, "/1/lists/show.json", args)
      end

    private

      def list_modify_member(args, &block)
        options = args.extract_options!
        user_to_add = args.pop
        options.merge_user!(user_to_add)
        list = args.pop
        options.merge_list!(list)
        unless options[:owner_id] || options[:owner_screen_name]
          owner = args.pop || self.verify_credentials.screen_name
          options.merge_owner!(owner)
        end
        response = yield(options)
        Twitter::List.from_response(response)
      end

      def list_modify_members(args, &block)
        options = args.extract_options!
        members = args.pop
        options.merge_list!(args.pop)
        unless options[:owner_id] || options[:owner_screen_name]
          owner = args.pop || self.verify_credentials.screen_name
          options.merge_owner!(owner)
        end
        response = members.flatten.each_slice(MAX_USERS_PER_REQUEST).threaded_map do |users|
          yield(options.merge_users(users))
        end.last
        Twitter::List.from_response(response)
      end

      def list_user?(args, &block)
        options = args.extract_options!
        user_to_check = args.pop
        options.merge_user!(user_to_check)
        list = args.pop
        options.merge_list!(list)
        unless options[:owner_id] || options[:owner_screen_name]
          owner = args.pop || self.verify_credentials.screen_name
          options.merge_owner!(owner)
        end
        yield(options)
        true
      rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
        false
      end

      def list_users(args, &block)
        options = {:cursor => -1}.merge(args.extract_options!)
        list = args.pop
        options.merge_list!(list)
        unless options[:owner_id] || options[:owner_screen_name]
          owner = args.pop || self.verify_credentials.screen_name
          options.merge_owner!(owner)
        end
        response = yield(options)
        Twitter::Cursor.from_response(response, 'users', Twitter::User)
      end

      def list_from_response(method, url, args)
        options = args.extract_options!
        list = args.pop
        options.merge_list!(list)
        unless options[:owner_id] || options[:owner_screen_name]
          owner = args.pop || self.verify_credentials.screen_name
          options.merge_owner!(owner)
        end
        response = self.send(method, url, options)
        Twitter::List.from_response(response)
      end

    end
  end
end
