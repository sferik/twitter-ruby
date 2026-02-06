require "equalizer"
require "memoizable"
require "twitter/base"

module Twitter
  # Represents a Twitter user suggestion category
  class Suggestion < Base
    include Equalizer.new(:slug)
    include Memoizable

    # The number of users in this category
    #
    # @api public
    # @example
    #   suggestion.size
    # @return [Integer]
    attr_reader :size

    # The name of the suggestion category
    #
    # @api public
    # @example
    #   suggestion.name
    # @return [String]

    # The slug of the suggestion category
    #
    # @api public
    # @example
    #   suggestion.slug
    # @return [String]
    attr_reader :name, :slug

    # Returns the users in this suggestion category
    #
    # @api public
    # @example
    #   suggestion.users
    # @return [Array<Twitter::User>]
    def users
      @attrs.fetch(:users, []).collect do |user|
        User.new(user)
      end
    end
    memoize :users
  end
end
