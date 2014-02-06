require 'equalizer'
require 'twitter/base'

module Twitter
  class Trend < Twitter::Base
    include Equalizer.new(:name)
    attr_reader :events, :name, :promoted_content, :query
    uri_attr_reader :uri

    def attributes
        @attrs
    end

    def attr
        @attrs
    end

    
  end
end
