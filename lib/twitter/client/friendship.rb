module Twitter
  class Client
    # Defines methods related to friendship
    module Friendship
      # Allows the authenticating user to follow the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/create
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :follow (false) Enable notifications for the target user.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The followed user.
      # @example Follow @sferik
      #   Twitter.follow("sferik")
      def follow(user, options={})
        merge_user_into_options!(user, options)
        # Twitter always turns on notifications if the "follow" option is present, even if it's set to false
        # so only send follow if it's true
        options.merge!(:follow => true) if options.delete(:follow)
        response = post('1/friendships/create', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end
      alias :friendship_create :follow

      # Allows the authenticating user to unfollow the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/destroy
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The unfollowed user.
      # @example Unfollow @sferik
      #   Twitter.unfollow("sferik")
      def unfollow(user, options={})
        merge_user_into_options!(user, options)
        response = delete('1/friendships/destroy', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end
      alias :friendship_destroy :unfollow

      # Test for the existence of friendship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/exists
      # @note Consider using {Twitter::Client::Friendship#friendship} instead of this method.
      # @rate_limited Yes
      # @requires_authentication No unless user_a or user_b is protected
      # @response_format `json`
      # @response_format `xml`
      # @param user_a [Integer, String] The ID or screen_name of the subject user.
      # @param user_b [Integer, String] The ID or screen_name of the user to test for following.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if user_a follows user_b, otherwise false.
      # @example Return true if @sferik follows @pengwynn
      #   Twitter.friendship?("sferik", "pengwynn")
      def friendship?(user_a, user_b, options={})
        response = get('1/friendships/exists', options.merge(:user_a => user_a, :user_b => user_b))
        format.to_s.downcase == 'xml' ? !%w(0 false).include?(response['friends']) : response
      end

      # Test for the existence of friendship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/exists
      # @deprecated {Twitter::Client::Friendship#friendship_exists?} is deprecated and will be removed in the next major version. Please use {Twitter::Client::Friendship#friendship?} instead.
      # @rate_limited Yes
      # @requires_authentication No unless user_a or user_b is protected
      # @response_format `json`
      # @response_format `xml`
      # @param user_a [Integer, String] The ID or screen_name of the subject user.
      # @param user_b [Integer, String] The ID or screen_name of the user to test for following.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if user_a follows user_b, otherwise false.
      # @example Return true if @sferik follows @pengwynn
      #   Twitter.friendship_exists?("sferik", "pengwynn")
      def friendship_exists?(user_a, user_b, options={})
        warn "#{caller.first}: [DEPRECATION] #friendship_exists? is deprecated and will be removed in the next major version. Please use #friendship? instead."
        friendship?(user_a, user_b, options={})
      end

      # Returns detailed information about the relationship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/show
      # @rate_limited Yes
      # @requires_authentication No
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :source_id The ID of the subject user.
      # @option options [String] :source_screen_name The screen_name of the subject user.
      # @option options [Integer] :target_id The ID of the target user.
      # @option options [String] :target_screen_name The screen_name of the target user.
      # @return [Hashie::Mash]
      # @example Return the relationship between @sferik and @pengwynn
      #   Twitter.friendship(:source_screen_name => "sferik", :target_screen_name => "pengwynn")
      #   Twitter.friendship(:source_id => 7505382, :target_id => 14100886)
      def friendship(options={})
        get('1/friendships/show', options)['relationship']
      end
      alias :friendship_show :friendship

      # Returns an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/incoming
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @return [Hashie::Mash]
      # @example Return an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #   Twitter.friendships_incoming
      def friendships_incoming(options={})
        options = {:cursor => -1}.merge(options)
        response = get('1/friendships/incoming', options)
        format.to_s.downcase == 'xml' ? Hashie::Mash.new(:ids => response['id_list']['ids']['id'].map{|id| id.to_i}) : response
      end

      # Returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/outgoing
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @return [Hashie::Mash]
      # @example Return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #   Twitter.friendships_outgoing
      def friendships_outgoing(options={})
        options = {:cursor => -1}.merge(options)
        response = get('1/friendships/outgoing', options)
        format.to_s.downcase == 'xml' ? Hashie::Mash.new(:ids => response['id_list']['ids']['id'].map{|id| id.to_i}) : response
      end
    end
  end
end
