require 'equalizer'
require 'twitter/base'

module Twitter
  class Trend < Twitter::Base
    include Equalizer.new(:name)
    attr_reader :events, :name, :query
    predicate_attr_reader :promoted_content
    uri_attr_reader :uri
  end
end
