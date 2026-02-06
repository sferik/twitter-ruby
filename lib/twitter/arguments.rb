module Twitter
  # An Array subclass that extracts options from arguments
  class Arguments < Array
    # The options hash extracted from the arguments
    #
    # @api public
    # @example
    #   args = Twitter::Arguments.new([:user1, :user2, {trim_user: true}])
    #   args.options # => {trim_user: true}
    # @return [Hash]
    attr_reader :options

    # Initializes a new Arguments object
    #
    # @api public
    # @example
    #   args = Twitter::Arguments.new([:user1, :user2, {trim_user: true}])
    #   args # => [:user1, :user2]
    #   args.options # => {trim_user: true}
    # @param args [Array] An array of arguments, optionally ending with a Hash
    # @return [Twitter::Arguments]
    def initialize(args)
      @options = args.last.is_a?(::Hash) ? args.pop : {}
      super(args.flatten)
    end
  end
end
