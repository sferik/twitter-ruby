require 'twitter/api/arguments'
require 'twitter/api/utils'
require 'twitter/suggestion'
require 'twitter/user'

module Twitter
  module API
    module SuggestedUsers
      include Twitter::API::Utils

      # @return [Array<Twitter::Suggestion>]
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @overload suggestions(options={})
      #   Returns the list of suggested user categories
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/users/suggestions
      #   @param options [Hash] A customizable set of options.
      #   @example Return the list of suggested user categories
      #     Twitter.suggestions
      # @overload suggestions(slug, options={})
      #   Returns the users in a given category
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/users/suggestions/:slug
      #   @param slug [String] The short name of list or a category.
      #   @param options [Hash] A customizable set of options.
      #   @example Return the users in the Art & Design category
      #     Twitter.suggestions("art-design")
      def suggestions(*args)
        arguments = Twitter::API::Arguments.new(args)
        if slug = arguments.pop
          object_from_response(Twitter::Suggestion, :get, "/1.1/users/suggestions/#{slug}.json", arguments.options)
        else
          objects_from_response(Twitter::Suggestion, :get, "/1.1/users/suggestions.json", arguments.options)
        end
      end

      # Access the users in a given category of the Twitter suggested user list and return their most recent Tweet if they are not a protected user
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/users/suggestions/:slug/members
      # @rate_limited Yes
      # @authentication Requires user context
      # @param slug [String] The short name of list or a category.
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::User>]
      # @example Return the users in the Art & Design category and their most recent Tweet if they are not a protected user
      #   Twitter.suggest_users("art-design")
      def suggest_users(slug, options={})
        objects_from_response(Twitter::User, :get, "/1.1/users/suggestions/#{slug}/members.json", options)
      end

    end
  end
end
