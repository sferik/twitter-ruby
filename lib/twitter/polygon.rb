require 'twitter/base'

module Twitter
  class Polygon < Twitter::Base
    attr_reader :coordinates
  end
end
