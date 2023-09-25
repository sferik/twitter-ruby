require "equalizer"
require "X/base"

module X
  class Trend < X::Base
    include Equalizer.new(:name)
    # @return [String]
    attr_reader :events, :name, :query, :tweet_volume

    predicate_attr_reader :promoted_content
    uri_attr_reader :uri
  end
end
