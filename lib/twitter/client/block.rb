module Twitter
  class Client
    # Defines methods related to blocking and unblocking users
    # @see Twitter::Client::SpamReporting
    module Block
      # Blocks the user specified by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/blocks/create
      # @note Destroys a friendship to the blocked user if it exists.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The blocked user.
      # @example Block and unfriend @sferik as the authenticating user
      #   Twitter.block("sferik")
      #   Twitter.block(7505382)  # Same as above
      def block(user, options={})
        merge_user_into_options!(user, options)
        response = post('1/blocks/create', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Un-blocks the user specified by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/blocks/destroy
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The un-blocked user.
      # @example Un-block @sferik as the authenticating user
      #   Twitter.unblock("sferik")
      #   Twitter.unblock(7505382)  # Same as above
      def unblock(user, options={})
        merge_user_into_options!(user, options)
        response = delete('1/blocks/destroy', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Returns true if the authenticating user is blocking a target user
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/exists
      # @requires_authentication Yes
      # @rate_limited Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if the authenticating user is blocking the target user, otherwise false.
      # @example Check whether the authenticating user is blocking @sferik
      #   Twitter.block?("sferik")
      #   Twitter.block?(7505382)  # Same as above
      def block?(user, options={})
        merge_user_into_options!(user, options)
        get('1/blocks/exists', options, :format => :json, :raw => true)
        true
      rescue Twitter::NotFound
        false
      end

      # Returns true if the authenticating user is blocking a target user
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/exists
      # @deprecated {Twitter::Client::Block#block_exists?} is deprecated and will be removed in the next major version. Please use {Twitter::Client::Block#block?} instead.
      # @requires_authentication Yes
      # @rate_limited Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if the authenticating user is blocking the target user, otherwise false.
      # @example Check whether the authenticating user is blocking @sferik
      #   Twitter.block?("sferik")
      #   Twitter.block?(7505382)  # Same as above
      def block_exists?(user, options={})
        warn "#{caller.first}: [DEPRECATION] #block_exists? is deprecated and will be removed in the next major version. Please use #block? instead."
        block?(user, options)
      end

      # Returns an array of user objects that the authenticating user is blocking
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array] User objects that the authenticating user is blocking.
      # @example Return an array of user objects that the authenticating user is blocking
      #   Twitter.blocking
      def blocking(options={})
        response = get('1/blocks/blocking', options)
        format.to_s.downcase == 'xml' ? response['users'] : response
      end

      # Returns an array of numeric user ids the authenticating user is blocking
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking/ids
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @return [Array] Numeric user ids the authenticating user is blocking.
      # @example Return an array of numeric user ids the authenticating user is blocking
      #   Twitter.blocking_ids
      def blocked_ids(options={})
        response = get('1/blocks/blocking/ids', options)
        format.to_s.downcase == 'xml' ? response['ids']['id'].map{|id| id.to_i} : response
      end
    end
  end
end
