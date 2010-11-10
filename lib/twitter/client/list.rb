module Twitter
  class Client
    # Defines methods related to lists
    # @see Twitter::Client::ListMembers
    # @see Twitter::Client::ListSubscribers
    module List
      # Creates a new list for the authenticated user
      #
      # @note Accounts are limited to 20 lists.
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @param screen_name [String] A Twitter screen name.
      # @param name [String] The name for the list.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      # @option options [String] :description The description to give the list.
      # @return [Hashie::Mash] The created list.
      # @see http://dev.twitter.com/doc/post/:user/lists
      # @example Create a list named "presidents"
      #   Twitter.list_create("sferik", "presidents")
      def list_create(screen_name, name, options={})
        clean_screen_name!(screen_name)
        response = post("#{screen_name}/lists", options.merge(:name => name))
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Updates the specified list
      #
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @param screen_name [String] A Twitter screen name.
      # @param name [String] The name for the list.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      # @option options [String] :description The description to give the list.
      # @return [Hashie::Mash] The created list.
      # @see http://dev.twitter.com/doc/post/:user/lists/:id
      # @example Update the "presidents" list to have the description "Presidents of the United States of America"
      #   Twitter.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
      def list_update(screen_name, name, options={})
        clean_screen_name!(screen_name)
        response = put("#{screen_name}/lists/#{name}", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # List the lists of the specified user
      #
      # @note Private lists will be included if the authenticated user is the same as the user whose lists are being returned.
      # @overload lists(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Hashie::Mash]
      #   @example List the authenticated user's lists
      #     Twitter.lists
      # @overload lists(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Hashie::Mash]
      #   @example List @sferik's lists
      #     Twitter.lists("sferik")
      # @see http://dev.twitter.com/doc/get/statuses/friends
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      def lists(*args)
        options = {:cursor => -1}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        screen_name = args.first
        if screen_name
          clean_screen_name!(screen_name)
          response = get("#{screen_name}/lists", options)
        else
          response = get('lists', options)
        end
        format.to_s.downcase == 'xml' ? response['lists_list'] : response
      end

      # Show the specified list
      #
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      # @note Private lists will only be shown if the authenticated user owns the specified list.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param screen_name [String] A Twitter screen name.
      # @param id [Integer, String] The id or slug of the list.
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash] The specified list.
      # @see http://dev.twitter.com/doc/get/:user/lists/:id
      # @example Show @sferik's "presidents" list
      #   Twitter.list("sferik", "presidents")
      def list(screen_name, id, options={})
        clean_screen_name!(screen_name)
        response = get("#{screen_name}/lists/#{id}", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Deletes the specified list
      #
      # @note Must be owned by the authenticated user.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited false
      # @param screen_name [String] A Twitter screen name.
      # @param id [Integer, String] The id or slug of the list.
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash] The deleted list.
      # @see http://dev.twitter.com/doc/delete/:user/lists/:id
      # @example Delete @sferik's "presidents" list
      #   Twitter.list_delete("sferik", "presidents")
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      def list_delete(screen_name, id, options={})
        clean_screen_name!(screen_name)
        response = delete("#{screen_name}/lists/#{id}", options)
        format.to_s.downcase == 'xml' ? response['list'] : response
      end

      # Show tweet timeline for members of the specified list
      #
      # @format :json, :xml
      # @authenticated false
      # @rate_limited true
      # @param screen_name [String] A Twitter screen name.
      # @param id [Integer, String] The id or slug of the list.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :per_page The number of results to retrieve.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/:user/lists/:id/statuses
      # @example Show tweet timeline for members of @sferik's "presidents" list
      #   Twitter.list_timeline("sferik", "presidents")
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      def list_timeline(screen_name, name, options={})
        clean_screen_name!(screen_name)
        response = get("#{screen_name}/lists/#{name}/statuses", options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      # List the lists the specified user has been added to
      #
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param screen_name [String] A Twitter screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/:user/lists/memberships
      # @example List the lists that @sferik has been added to
      #   Twitter.memberships("sferik")
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      def memberships(screen_name, options={})
        options = {:cursor => -1}.merge(options)
        clean_screen_name!(screen_name)
        response = get("#{screen_name}/lists/memberships", options)
        format.to_s.downcase == 'xml' ? response['lists_list'] : response
      end

      # List the lists the specified user follows
      #
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param screen_name [String] A Twitter screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/:user/lists/subscriptions
      # @example List the lists that @sferik follows
      #   Twitter.subscriptions("sferik")
      # @todo Overload the method to allow fetching of the authenticated user's screen name from configuration.
      def subscriptions(screen_name, options={})
        options = {:cursor => -1}.merge(options)
        clean_screen_name!(screen_name)
        response = get("#{screen_name}/lists/subscriptions", options)
        format.to_s.downcase == 'xml' ? response['lists_list'] : response
      end
    end
  end
end
