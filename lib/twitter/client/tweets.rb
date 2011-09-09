module Twitter
  class Client
    # Defines methods related to tweets
    module Tweets
      # Returns a single status, specified by ID
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/show/:id
      # @rate_limited Yes
      # @requires_authentication No unless the author of the status is protected
      # @response_format `json`
      # @response_format `xml`
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The requested status.
      # @example Return the status with the ID 25938088801
      #   Twitter.status(25938088801)
      def status(id, options={})
        response = get("1/statuses/show/#{id}", options)
        format.to_s.downcase == 'xml' ? response['status'] : response
      end

      # Updates the authenticating user's status
      #
      # @see https://dev.twitter.com/docs/api/1/post/statuses/update
      # @note A status update with text identical to the authenticating user's current status will be ignored to prevent duplicates.
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param status [String] The text of your status update, up to 140 characters.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
      # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
      # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::Client::Geo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The created status.
      # @example Update the authenticating user's status
      #   Twitter.update("I just posted a status update via the Twitter Ruby Gem!")
      def update(status, options={})
        response = post('1/statuses/update', options.merge(:status => status))
        format.to_s.downcase == 'xml' ? response['status'] : response
      end

      # Updates with media the authenticating user's status
      #
      # @note A status update with text/media identical to the authenticating user's current status will NOT be ignored
      # @requires_authentication Yes
      # @rate_limited No
      # @response_format `json`
      # @response_format `xml`
      # @param status [String] The text of your status update, up to 140 characters.
      # @param media [File] A File object with your picture (PNG, JPEG or GIF)
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
      # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
      # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::Client::Geo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The created status.
      # @see http://dev.twitter.com/docs/api/1/post/statuses/update_with_media
      # @example Update the authenticating user's status
      #   When you have a File instance (e.g. the pic is already on your disk)
      #   Twitter.update_with_media("I just posted a status update with a pic via the Twitter Ruby Gem!", File.new('my_awesome_pic.jpeg'))
      #   When you have an IO instance (e.g. your pic is on S3 and you don't want to write a temp file on the disk),
      #     download the pic and put the response in a StringIO object
      #   Twitter.update_with_media("I just posted a status update with a pic via the Twitter Ruby Gem!", {'io' => StringIO.new(pic), 'type' => 'jpg'})
      def update_with_media(status, image, options={})
        response = post('1/statuses/update_with_media', options.merge('media[]' => image, 'status' => status), :endpoint => media_endpoint)
        format.to_s.downcase == 'xml' ? response['status'] : response
      end

      # Destroys the specified status
      #
      # @see https://dev.twitter.com/docs/api/1/post/statuses/destroy/:id
      # @note The authenticating user must be the author of the specified status.
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The deleted status.
      # @example Destroy the status with the ID 25938088801
      #   Twitter.status_destroy(25938088801)
      def status_destroy(id, options={})
        response = delete("1/statuses/destroy/#{id}", options)
        format.to_s.downcase == 'xml' ? response['status'] : response
      end

      # Retweets a tweet
      #
      # @see https://dev.twitter.com/docs/api/1/post/statuses/retweet/:id
      # @note The authenticating user must be the author of the specified status.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The original tweet with retweet details embedded.
      # @example Retweet the status with the ID 28561922516
      #   Twitter.retweet(28561922516)
      def retweet(id, options={})
        response = post("1/statuses/retweet/#{id}", options)
        format.to_s.downcase == 'xml' ? response['status'] : response
      end

      # Returns up to 100 of the first retweets of a given tweet
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweets/:id
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array]
      # @example Return up to 100 of the first retweets of the status with the ID 28561922516
      #   Twitter.retweets(28561922516)
      def retweets(id, options={})
        response = get("1/statuses/retweets/#{id}", options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      # Show up to 100 users who retweeted the status
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/:id/retweeted_by
      # @see https://dev.twitter.com/docs/api/1/get/statuses/:id/retweeted_by/ids
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Boolean] :ids_only ('false') Only return user ids instead of full user objects.
      # @return [Array]
      # @example Show up to 100 users who retweeted the status with the ID 28561922516
      #   Twitter.retweeters_of(28561922516)
      def retweeters_of(id, options={})
        ids_only = !!options.delete(:ids_only)
        response = get("1/statuses/#{id}/retweeted_by#{'/ids' if ids_only}", options)
        format.to_s.downcase == 'xml' ? response['users'] : response
      end
    end
  end
end
