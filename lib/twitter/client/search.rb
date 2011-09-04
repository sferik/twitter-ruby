module Twitter
  class Client
    # Defines methods related to Search
    module Search
      # Returns recent images related to a query
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication No
      # @response_format `json`
      # @response_format `xml`
      # @param q [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array] An array of statuses that contain images
      # @example Return recent images related to twitter
      #   Twitter.image_facets('twitter')
      def image_facets(q, options={})
        response = get('i/search/image_facets', options.merge(:q => q))
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      # Returns recent videos related to a query
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication No
      # @response_format `json`
      # @response_format `xml`
      # @param q [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array] An array of statuses that contain videos
      # @example Return recent videos related to twitter
      #   Twitter.video_facets('twitter')
      def video_facets(q, options={})
        response = get('i/search/video_facets', options.merge(:q => q))
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end
    end
  end
end
