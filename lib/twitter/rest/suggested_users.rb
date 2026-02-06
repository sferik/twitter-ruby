require "twitter/arguments"
require "twitter/rest/utils"
require "twitter/suggestion"
require "twitter/user"

module Twitter
  module REST
    # Methods for accessing suggested users
    module SuggestedUsers
      include Twitter::REST::Utils

      # Returns suggested user categories or users in a category
      #
      # @api public
      # @return [Array<Twitter::Suggestion>]
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.suggestions
      # @overload suggestions(options = {})
      #   Returns the list of suggested user categories
      #
      #   @see https://dev.twitter.com/rest/reference/get/users/suggestions
      #   @param options [Hash] A customizable set of options.
      # @overload suggestions(slug, options = {})
      #   Returns the users in a given category
      #
      #   @see https://dev.twitter.com/rest/reference/get/users/suggestions/:slug
      #   @param slug [String] The short name of list or a category.
      #   @param options [Hash] A customizable set of options.
      def suggestions(*args)
        arguments = Twitter::Arguments.new(args)
        if arguments.last
          perform_get_with_object("/1.1/users/suggestions/#{arguments.pop}.json", arguments.options, Twitter::Suggestion)
        else
          perform_get_with_objects("/1.1/users/suggestions.json", arguments.options, Twitter::Suggestion)
        end
      end

      # Returns users in a given category with their most recent Tweet
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/users/suggestions/:slug/members
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.suggest_users('technology')
      # @param slug [String] The short name of list or a category.
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::User>]
      def suggest_users(slug, options = {})
        perform_get_with_objects("/1.1/users/suggestions/#{slug}/members.json", options, Twitter::User)
      end
    end
  end
end
