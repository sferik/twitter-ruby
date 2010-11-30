module Twitter
  class Client
    # Defines methods related to list subscribers
    # @see Twitter::Client::List
    # @see Twitter::Client::ListMembers
    module ListSubscribers
      # Returns the subscribers of the specified list
      #
      # @overload list_subscribers(screen_name, list_id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array] The subscribers of the specified list.
      #   @example Return the subscribers of of @sferik's "presidents" list
      #     Twitter.list_subscribers("sferik", "presidents")
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @see http://dev.twitter.com/doc/get/:user/:list_id/subscribers
      def list_subscribers(*args)
        options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
        list_id = args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        response = get("#{screen_name}/#{list_id}/subscribers", options)
        format.to_s.downcase == 'xml' ? response['users_list'] : response
      end

      # Unsubscribes the authenticated user form the specified list
      #
      # @overload list_subscribe(screen_name, list_id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The specified list.
      #   @example Subscribe to @sferik's "presidents" list
      #     Twitter.list_subscribe("sferik", "presidents")
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @see http://dev.twitter.com/doc/post/:user/:list_id/subscribers
      def list_subscribe(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list_id = args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        response = post("#{screen_name}/#{list_id}/subscribers", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Make the authenticated user follow the specified list
      #
      # @overload list_unsubscribe(screen_name, list_id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] The specified list.
      #   @example Unsubscribe from @sferik's "presidents" list
      #     Twitter.list_unsubscribe("sferik", "presidents")
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @see http://dev.twitter.com/doc/delete/:user/:list_id/subscribers
      def list_unsubscribe(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        list_id = args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        response = delete("#{screen_name}/#{list_id}/subscribers", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Check if a user is a subscriber of the specified list
      #
      # @overload is_subscriber?(screen_name, list_id, id, options={})
      #   @param screen_name [String] A Twitter screen name.
      #   @param list_id [Integer, String] The id or slug of the list.
      #   @param id [Integer] The user id of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
      #     Twitter.is_subscriber?("sferik", "presidents", 813286)
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @see http://dev.twitter.com/doc/get/:user/:list_id/subscribers/:id
      def is_subscriber?(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id, list_id = args.pop, args.pop
        screen_name = args.pop || get_screen_name
        clean_screen_name!(screen_name)
        begin
          get("#{screen_name}/#{list_id}/subscribers/#{id}", options)
          true
        rescue Twitter::NotFound
          false
        end
      end
    end
  end
end
