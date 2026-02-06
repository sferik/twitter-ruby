require "equalizer"
require "twitter/base"

module Twitter
  # Represents a Twitter trending topic
  class Trend < Twitter::Base
    include Equalizer.new(:name)

    # Events associated with this trend
    #
    # @api public
    # @example
    #   trend.events
    # @return [String]

    # The name of the trend
    #
    # @api public
    # @example
    #   trend.name
    # @return [String]

    # The search query for this trend
    #
    # @api public
    # @example
    #   trend.query
    # @return [String]

    # The tweet volume for this trend
    #
    # @api public
    # @example
    #   trend.tweet_volume
    # @return [Integer]
    attr_reader :events, :name, :query, :tweet_volume

    predicate_attr_reader :promoted_content
    uri_attr_reader :uri
  end
end
