require "twitter/base"

module Twitter
  # Represents a Twitter supported language
  class Language < Base
    # The language code
    #
    # @api public
    # @example
    #   language.code
    # @return [String]

    # The language name
    #
    # @api public
    # @example
    #   language.name
    # @return [String]

    # The language status
    #
    # @api public
    # @example
    #   language.status
    # @return [String]
    attr_reader :code, :name, :status
  end
end
