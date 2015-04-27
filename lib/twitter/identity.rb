require 'equalizer'
require 'twitter/base'

module Twitter
  class Identity < Twitter::Base
    include Equalizer.new(:id)
    # @return [Integer]
    attr_reader :id
  end
end
