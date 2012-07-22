require 'twitter/api/utils'
require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/core_ext/hash'
require 'twitter/cursor'
require 'twitter/error/not_found'
require 'twitter/suggestion'
require 'twitter/user'

module Twitter
  module API
    module Users
      include Twitter::API::Utils
      MAX_USERS_PER_REQUEST = 100

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :suggestions => true,
            :suggest_users => true,
            :users => true,
            :user_search => true,
            :user => true,
            :user? => true,
            :contributees => true,
            :contributors => true,
            :recommendations => true,
            :following_followers_of => true,
          }
        )
      end

      # @return [Array<Twitter::Suggestion>]
      # @rate_limited Yes
      # @authentication_required No
      # @overload suggestions(options={})
      #   Returns the list of suggested user categories
      #
      #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions
      #   @param options [Hash] A customizable set of options.
      #   @example Return the list of suggested user categories
      #     Twitter.suggestions
      # @overload suggestions(slug, options={})
      #   Returns the users in a given category
      #
      #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug
      #   @param slug [String] The short name of list or a category.
      #   @param options [Hash] A customizable set of options.
      #   @example Return the users in the Art & Design category
      #     Twitter.suggestions("art-design")
      def suggestions(*args)
        options = args.extract_options!
        if slug = args.pop
          response = get("/1/users/suggestions/#{slug}.json", options)
          Twitter::Suggestion.from_response(response)
        else
          response = get("/1/users/suggestions.json", options)
          collection_from_array(response[:body], Twitter::Suggestion)
        end
      end

      # Access the users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug/members
      # @rate_limited Yes
      # @authentication_required No
      # @param slug [String] The short name of list or a category.
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::User>]
      # @example Return the users in the Art & Design category and their most recent status if they are not a protected user
      #   Twitter.suggest_users("art-design")
      def suggest_users(slug, options={})
        response = get("/1/users/suggestions/#{slug}/members.json", options)
        collection_from_array(response[:body], Twitter::User)
      end

      # Returns extended information for up to 100 users
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/lookup
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The requested users.
      # @overload users(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Return extended information for @sferik and @pengwynn
      #     Twitter.users('sferik', 'pengwynn')
      #     Twitter.users(7505382, 14100886)    # Same as above
      # @overload users(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def users(*args)
        options = args.extract_options!
        args.flatten.each_slice(MAX_USERS_PER_REQUEST).threaded_map do |users|
          response = get("/1/users/lookup.json", options.merge_users(users))
          collection_from_array(response[:body], Twitter::User)
        end.flatten
      end

      # Returns users that match the given query
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/search
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>]
      # @param query [String] The search query to run against people search.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :per_page The number of people to retrieve. Maxiumum of 20 allowed per page.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @example Return users that match "Erik Michaels-Ober"
      #   Twitter.user_search("Erik Michaels-Ober")
      def user_search(query, options={})
        response = get("/1/users/search.json", options.merge(:q => query))
        collection_from_array(response[:body], Twitter::User)
      end

      # @see https://dev.twitter.com/docs/api/1/get/users/show
      # @rate_limited Yes
      # @authentication_required No
      # @return [Twitter::User] The requested user.
      # @overload user(options={})
      #   Returns extended information for the authenticated user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include user's statuses when set to true, 't' or 1.
      #   @example Return extended information for the authenticated user
      #     Twitter.user
      # @overload user(user, options={})
      #   Returns extended information for a given user
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Return extended information for @sferik
      #     Twitter.user('sferik')
      #     Twitter.user(7505382)  # Same as above
      def user(*args)
        options = args.extract_options!
        if user = args.pop
          options.merge_user!(user)
          response = get("/1/users/show.json", options)
          Twitter::User.from_response(response)
        else
          self.verify_credentials(options)
        end
      end

      # Returns true if the specified user exists
      #
      # @authentication_required No
      # @rate_limited Yes
      # @return [Boolean] true if the user exists, otherwise false.
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      # @example Return true if @sferik exists
      #   Twitter.user?('sferik')
      #   Twitter.user?(7505382)  # Same as above
      def user?(user, options={})
        options.merge_user!(user)
        get("/1/users/show.json", options)
        true
      rescue Twitter::Error::NotFound
        false
      end

      # Returns an array of users that the specified user can contribute to
      #
      # @see http://dev.twitter.com/docs/api/1/get/users/contributees
      # @rate_limited Yes
      # @authentication_required No unless requesting it from a protected user
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>]
      # @overload contributees(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @example Return the authenticated user's contributees
      #     Twitter.contributees
      # @overload contributees(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @example Return users @sferik can contribute to
      #     Twitter.contributees('sferik')
      #     Twitter.contributees(7505382)  # Same as above
      def contributees(*args)
        options = args.extract_options!
        user = args.pop || self.verify_credentials.screen_name
        options.merge_user!(user)
        response = get("/1/users/contributees.json", options)
        collection_from_array(response[:body], Twitter::User)
      end

      # Returns an array of users who can contribute to the specified account
      #
      # @see http://dev.twitter.com/docs/api/1/get/users/contributors
      # @rate_limited Yes
      # @authentication_required No unless requesting it from a protected user
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>]
      # @overload contributors(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @example Return the authenticated user's contributors
      #     Twitter.contributors
      # @overload contributors(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @example Return users who can contribute to @sferik's account
      #     Twitter.contributors('sferik')
      #     Twitter.contributors(7505382)  # Same as above
      def contributors(*args)
        options = args.extract_options!
        user = args.pop || self.verify_credentials.screen_name
        options.merge_user!(user)
        response = get("/1/users/contributors.json", options)
        collection_from_array(response[:body], Twitter::User)
      end

      # Returns recommended users for the authenticated user
      #
      # @note {https://dev.twitter.com/discussions/1120 Undocumented}
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>]
      # @overload recommendations(options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :limit (20) Specifies the number of records to retrieve.
      #   @option options [String] :excluded Comma-separated list of user IDs to exclude.
      #   @example Return recommended users for the authenticated user
      #     Twitter.recommendations
      # @overload recommendations(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :limit (20) Specifies the number of records to retrieve.
      #   @option options [String] :excluded Comma-separated list of user IDs to exclude.
      #   @example Return recommended users for the authenticated user
      #     Twitter.recommendations("sferik")
      def recommendations(*args)
        options = args.extract_options!
        user = args.pop || self.verify_credentials.screen_name
        options.merge_user!(user)
        options[:excluded] = options[:excluded].join(',') if options[:excluded].is_a?(Array)
        response = get("/1/users/recommendations.json", options)
        response[:body].map do |recommendation|
          Twitter::User.fetch_or_new(recommendation[:user])
        end
      end

      # @note Undocumented
      # @rate_limited Yes
      # @authentication_required Yes
      #
      # @overload following_followers_of(options={})
      #   Returns users following followers of the specified user
      #
      #   @param options [Hash] A customizable set of options.
      #     @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #     @return [Twitter::Cursor]
      #   @example Return users follow followers of @sferik
      #     Twitter.following_followers_of
      #
      # @overload following_followers_of(user, options={})
      #   Returns users following followers of the authenticated user
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #     @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #     @return [Twitter::Cursor]
      #   @example Return users follow followers of @sferik
      #     Twitter.following_followers_of('sferik')
      #     Twitter.following_followers_of(7505382)  # Same as above
      def following_followers_of(*args)
        options = {:cursor => -1}
        options.merge!(args.extract_options!)
        user = args.pop || self.verify_credentials.screen_name
        options.merge_user!(user)
        response = get("/users/following_followers_of.json", options)
        Twitter::Cursor.from_response(response, 'users', Twitter::User)
      end

    end
  end
end
