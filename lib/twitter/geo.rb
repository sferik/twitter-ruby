require 'equalizer'
require 'twitter/base'

module Twitter
  class Geo < Twitter::Base
    include Equalizer.new(:coordinates)
    attr_reader :coordinates
    alias coords coordinates
  end
end
