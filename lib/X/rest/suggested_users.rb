require "X/arguments"
require "X/rest/utils"
require "X/suggestion"
require "X/user"

module X
  module REST
    module SuggestedUsers
      include X::REST::Utils

      # @return [Array<X::Suggestion>]
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @overload suggestions(options = {})
      #   Returns the list of suggested user categories
      #
      #   @see https://dev.X.com/rest/reference/get/users/suggestions
      #   @param options [Hash] A customizable set of options.
      # @overload suggestions(slug, options = {})
      #   Returns the users in a given category
      #
      #   @see https://dev.X.com/rest/reference/get/users/suggestions/:slug
      #   @param slug [String] The short name of list or a category.
      #   @param options [Hash] A customizable set of options.
      def suggestions(*args)
        arguments = X::Arguments.new(args)
        if arguments.last
          perform_get_with_object("/1.1/users/suggestions/#{arguments.pop}.json", arguments.options, X::Suggestion)
        else
          perform_get_with_objects("/1.1/users/suggestions.json", arguments.options, X::Suggestion)
        end
      end

      # Access the users in a given category of the X suggested user list and return their most recent Tweet if they are not a protected user
      #
      # @see https://dev.X.com/rest/reference/get/users/suggestions/:slug/members
      # @rate_limited Yes
      # @authentication Requires user context
      # @param slug [String] The short name of list or a category.
      # @param options [Hash] A customizable set of options.
      # @return [Array<X::User>]
      def suggest_users(slug, options = {})
        perform_get_with_objects("/1.1/users/suggestions/#{slug}/members.json", options, X::User)
      end
    end
  end
end
