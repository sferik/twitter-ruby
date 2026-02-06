require "twitter/creatable"
require "twitter/identity"

module Twitter
  # Represents a saved search
  class SavedSearch < Twitter::Identity
    include Twitter::Creatable

    # The name of the saved search
    #
    # @api public
    # @example
    #   saved_search.name
    # @return [String]

    # The position of the saved search
    #
    # @api public
    # @example
    #   saved_search.position
    # @return [String]

    # The query of the saved search
    #
    # @api public
    # @example
    #   saved_search.query
    # @return [String]
    attr_reader :name, :position, :query
  end
end
