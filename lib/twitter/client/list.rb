require 'twitter/list'
require 'twitter/paginator'
require 'twitter/status'

module Twitter
  class Client
    # Defines methods related to lists
    # @see Twitter::Client::ListMembers
    # @see Twitter::Client::ListSubscribers
    module List
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
      # @example Create a list named "presidents"
      #   Twitter.list_create("presidents")
      # @return [Twitter::List] The created list.
      def list_create(name, options={})
        list = post("/1/lists/create.json", options.merge(:name => name))
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
      #   @example Update the authenticated user's "presidents" list to have the description "Presidents of the United States of America"
      #     Twitter.list_update("presidents", :description => "Presidents of the United States of America")
      #     Twitter.list_update(8863586, :description => "Presidents of the United States of America")
      # @overload list_update(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug for the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      #   @option options [String] :description The description to give the list.
      #   @return [Twitter::List] The created list.
      #   @example Update the @sferik's "presidents" list to have the description "Presidents of the United States of America"
      #     Twitter.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
      #     Twitter.list_update(7505382, "presidents", :description => "Presidents of the United States of America")
      #     Twitter.list_update("sferik", 8863586, :description => "Presidents of the United States of America")
      #     Twitter.list_update(7505382, 8863586, :description => "Presidents of the United States of America")
      # @return [Twitter::List] The created list.
      def list_update(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        list = post("/1/lists/update.json", options)
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
      #   @return [Twitter::Paginator]
      #   @example List the authenticated user's lists
      #     Twitter.lists
      # @overload lists(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Paginator]
      #   @example List @sferik's lists
      #     Twitter.lists("sferik")
      #     Twitter.lists(7505382)
      # @return [Twitter::List]
      def lists(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        user = args.first
        merge_user_into_options!(user, options) if user
        paginator = get("/1/lists.json", options)
        Twitter::Paginator.new(paginator, 'lists', Twitter::List)
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
      #   @example Show the authenticated user's "presidents" list
      #     Twitter.list("presidents")
      #     Twitter.list(8863586)
      # @overload list(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The specified list.
      #   @example Show @sferik's "presidents" list
      #     Twitter.list("sferik", "presidents")
      #     Twitter.list("sferik", 8863586)
      #     Twitter.list(7505382, "presidents")
      #     Twitter.list(7505382, 8863586)
      # @return [Twitter::List] The specified list.
      def list(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        list = get("/1/lists/show.json", options)
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
      #   @example Delete the authenticated user's "presidents" list
      #     Twitter.list_destroy("/presidents")
      #     Twitter.list_destroy(8863586)
      # @overload list_destroy(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Twitter::List] The deleted list.
      #   @example Delete @sferik's "presidents" list
      #     Twitter.list_destroy("/sferik", "presidents")
      #     Twitter.list_destroy("/sferik", 8863586)
      #     Twitter.list_destroy(7505382, "presidents")
      #     Twitter.list_destroy(7505382, 8863586)
      # @return [Twitter::List] The deleted list.
      def list_destroy(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        list = delete("/1/lists/destroy.json", options)
        Twitter::List.new(list)
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
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        get("/1/lists/statuses.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # List the lists the specified user has been added to
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/memberships
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload memberships(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Paginator]
      #   @example List the lists the authenticated user has been added to
      #     Twitter.memberships
      # @overload memberships(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Paginator]
      #   @example List the lists that @sferik has been added to
      #     Twitter.memberships("sferik")
      #     Twitter.memberships(7505382)
      def memberships(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        user = args.pop || get_screen_name
        merge_user_into_options!(user, options)
        paginator = get("/1/lists/memberships.json", options)
        Twitter::Paginator.new(paginator, 'lists', Twitter::List)
      end

      # List the lists the specified user follows
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscriptions
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload subscriptions(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Paginator]
      #   @example List the lists the authenticated user follows
      #     Twitter.subscriptions
      # @overload subscriptions(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Paginator]
      #   @example List the lists that @sferik follows
      #     Twitter.subscriptions("sferik")
      #     Twitter.subscriptions(7505382)
      def subscriptions(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        user = args.pop || get_screen_name
        merge_user_into_options!(user, options)
        paginator = get("/1/lists/subscriptions.json", options)
        Twitter::Paginator.new(paginator, 'lists', Twitter::List)
      end
    end
  end
end
