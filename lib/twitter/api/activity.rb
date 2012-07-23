require 'twitter/api/utils'
require 'twitter/action_factory'

module Twitter
  module API
    module Activity
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :activity_about_me => true,
            :activity_by_friends => true,
          }
        )
      end

      # Returns activity about me
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array] An array of actions
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @example Return activity about me
      #   Twitter.activity_about_me
      def activity_about_me(options={})
        collection_from_response(Twitter::ActionFactory, :get, "/i/activity/about_me.json", options)
      end

      # Returns activity by friends
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid./
      # @return [Array] An array of actions
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @example Return activity by friends
      #   Twitter.activity_by_friends
      def activity_by_friends(options={})
        collection_from_response(Twitter::ActionFactory, :get, "/i/activity/by_friends.json", options)
      end

    end
  end
end
