require "twitter/base"

module Twitter
  # Represents metadata about a search result
  class Metadata < Base
    # The ISO language code
    #
    # @api public
    # @example
    #   metadata.iso_language_code
    # @return [String]

    # The result type
    #
    # @api public
    # @example
    #   metadata.result_type
    # @return [String]
    attr_reader :iso_language_code, :result_type
  end
end
