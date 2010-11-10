module Twitter
  class Client
    # Defines methods related to list subscribers
    # @see Twitter::Client::List
    # @see Twitter::Client::ListMembers
    module ListSubscribers
      # Returns the subscribers of the specified list
      #
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param screen_name [String] A Twitter screen name.
      # @param list_id [Integer, String] The id or slug of the list.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array] The subscribers of the specified list.
      # @see http://dev.twitter.com/doc/get/:user/:list_id/subscribers
      # @example Return the subscribers of of @sferik's "presidents" list
      #   Twitter.list_subscribers("sferik", "presidents")
      def list_subscribers(screen_name, list_id, options={})
        options = {:cursor => -1}.merge(options)
        clean_screen_name!(screen_name)
        response = get("#{screen_name}/#{list_id}/subscribers", options)
        format.to_s.downcase == 'xml' ? response['users_list'] : response
      end

      # Unsubscribes the authenticated user form the specified list
      #
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @param screen_name [String] A Twitter screen name.
      # @param list_id [Integer, String] The id or slug of the list.
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash] The specified list.
      # @see http://dev.twitter.com/doc/post/:user/:list_id/subscribers
      # @example Subscribe to @sferik's "presidents" list
      #   Twitter.list_subscribe("sferik", "presidents")
      def list_subscribe(screen_name, list_id, options={})
        clean_screen_name!(screen_name)
        response = post("#{screen_name}/#{list_id}/subscribers", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Make the authenticated user follow the specified list
      #
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @param screen_name [String] A Twitter screen name.
      # @param list_id [Integer, String] The id or slug of the list.
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash] The specified list.
      # @see http://dev.twitter.com/doc/delete/:user/:list_id/subscribers
      # @example Unsubscribe from @sferik's "presidents" list
      #   Twitter.list_unsubscribe("sferik", "presidents")
      def list_unsubscribe(screen_name, list_id, options={})
        clean_screen_name!(screen_name)
        response = delete("#{screen_name}/#{list_id}/subscribers", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Check if a user is a subscriber of the specified list
      #
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param screen_name [String] A Twitter screen name.
      # @param list_id [Integer, String] The id or slug of the list.
      # @param id [Integer] The user id of the list member.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      # @see http://dev.twitter.com/doc/get/:user/:list_id/subscribers/:id
      # @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
      #   Twitter.is_subscriber?("sferik", "presidents", 813286)
      def is_subscriber?(screen_name, list_id, id, options={})
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
