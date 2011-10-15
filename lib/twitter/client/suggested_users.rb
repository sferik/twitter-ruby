require 'twitter/suggestion'
require 'twitter/user'

module Twitter
  class Client
    # Defines methods related to users
    module SuggestedUsers

      # @overload suggestions(options={})
      #   Returns the list of suggested user categories
      #
      #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions
      #   @rate_limited Yes
      #   @requires_authentication No
      #   @param options [Hash] A customizable set of options.
      #   @return [Array<Twitter::Suggestion>]
      #   @example Return the list of suggested user categories
      #     Twitter.suggestions
      # @overload suggestions(slug, options={})
      #   Returns the users in a given category
      #
      #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug
      #   @rate_limited Yes
      #   @requires_authentication No
      #   @param slug [String] The short name of list or a category.
      #   @param options [Hash] A customizable set of options.
      #   @return [Array<Twitter::Suggestion>]
      #   @example Return the users in the Art & Design category
      #     Twitter.suggestions("art-design")
      def suggestions(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if slug = args.first
          suggestion = get("/1/users/suggestions/#{slug}.json", options)
          Twitter::Suggestion.new(suggestion)
        else
          get("/1/users/suggestions.json", options).map do |suggestion|
            Twitter::Suggestion.new(suggestion)
          end
        end
      end

      # Access the users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug/members
      # @rate_limited Yes
      # @requires_authentication No
      # @param slug [String] The short name of list or a category.
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::User>]
      # @example Return the users in the Art & Design category and their most recent status if they are not a protected user
      #   Twitter.suggest_users("art-design")
      def suggest_users(slug, options={})
        get("/1/users/suggestions/#{slug}/members.json", options).map do |user|
          Twitter::User.new(user)
        end
      end

    end
  end
end
