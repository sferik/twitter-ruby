module Twitter
  class Client
    # Defines methods related to list subscribers
    # @see Twitter::Client::List
    # @see Twitter::Client::ListMembers
    module ListSubscribers
      # Returns the subscribers of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscriptions
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @overload list_subscribers(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array] The subscribers of the specified list.
      #   @example Return the subscribers of the authenticated user's "presidents" list
      #     Twitter.list_subscribers('presidents')
      #     Twitter.list_subscribers(8863586)
      # @overload list_subscribers(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array] The subscribers of the specified list.
      #   @example Return the subscribers of @sferik's "presidents" list
      #     Twitter.list_subscribers("sferik", 'presidents')
      #     Twitter.list_subscribers("sferik", 8863586)
      #     Twitter.list_subscribers(7505382, 'presidents')
      # @return [Array] The subscribers of the specified list.
      def list_subscribers(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        list = args.pop
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        response = get("1/lists/subscribers", options)
        format.to_s.downcase == 'xml' ? response['users_list'] : response
      end

      # Make the authenticated user follow the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/create
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @overload list_subscribe(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The specified list.
      #   @example Subscribe to the authenticated user's "presidents" list
      #     Twitter.list_subscribe('presidents')
      #     Twitter.list_subscribe(8863586)
      # @overload list_subscribe(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The specified list.
      #   @example Subscribe to @sferik's "presidents" list
      #     Twitter.list_subscribe("sferik", 'presidents')
      #     Twitter.list_subscribe("sferik", 8863586)
      #     Twitter.list_subscribe(7505382, 'presidents')
      # @return [Hashie::Mash] The specified list.
      def list_subscribe(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        response = post("1/lists/subscribers/create", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Unsubscribes the authenticated user form the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/destroy
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @overload list_unsubscribe(list, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The specified list.
      #   @example Unsubscribe from the authenticated user's "presidents" list
      #     Twitter.list_unsubscribe('presidents')
      #     Twitter.list_unsubscribe(8863586)
      # @overload list_unsubscribe(user, list, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The specified list.
      #   @example Unsubscribe from @sferik's "presidents" list
      #     Twitter.list_unsubscribe("sferik", 'presidents')
      #     Twitter.list_unsubscribe("sferik", 8863586)
      #     Twitter.list_unsubscribe(7505382, 'presidents')
      # @return [Hashie::Mash] The specified list.
      def list_unsubscribe(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list = args.pop
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        response = post("1/lists/subscribers/destroy", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Check if a user is a subscriber of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers/show
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @overload list_subscriber?(list, user_to_check, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_check [Integer, String] The user ID or screen_name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
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
      #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
      #     Twitter.list_subscriber?("sferik", 'presidents', 813286)
      #     Twitter.list_subscriber?("sferik", 8863586, 813286)
      #     Twitter.list_subscriber?(7505382, 'presidents', 813286)
      #     Twitter.list_subscriber?("sferik", 'presidents', 'BarackObama')
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      def list_subscriber?(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user_to_check, list = args.pop, args.pop
        user = args.pop || get_screen_name
        merge_list_into_options!(list, options)
        merge_owner_into_options!(user, options)
        merge_user_into_options!(user_to_check, options)
        get("1/lists/subscribers/show", options, :format => :json, :raw => true)
        true
      rescue Twitter::NotFound, Twitter::Forbidden
        false
      end

      # Check if a user is a subscriber of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers/show
      # @deprecated {Twitter::Client::ListSubscribers#is_subscriber?} is deprecated and will be removed in the next major version. Please use {Twitter::Client::ListSubscribers#list_subscriber?} instead.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @overload is_subscriber?(list, user_to_check, options={})
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_check [Integer, String] The user ID or screen_name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      #   @example Check if @BarackObama is a subscriber of the authenticated user's "presidents" list
      #     Twitter.is_subscriber?('presidents', 813286)
      #     Twitter.is_subscriber?(8863586, 813286)
      #     Twitter.is_subscriber?('presidents', 'BarackObama')
      # @overload is_subscriber?(user, list, user_to_check, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param list [Integer, String] The list_id or slug of the list.
      #   @param user_to_check [Integer, String] The user ID or screen_name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
      #     Twitter.is_subscriber?("sferik", 'presidents', 813286)
      #     Twitter.is_subscriber?("sferik", 8863586, 813286)
      #     Twitter.is_subscriber?(7505382, 'presidents', 813286)
      #     Twitter.is_subscriber?("sferik", 'presidents', 'BarackObama')
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      def is_subscriber?(*args)
        warn "#{caller.first}: [DEPRECATION] #is_subscriber? is deprecated and will be removed in the next major version. Please use #list_subscriber? instead."
        list_subscriber?(args)
      end
    end
  end
end
