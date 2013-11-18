require 'time'
require 'memoizable'

module Twitter
  module Creatable
    include Memoizable

    # Time when the object was created on Twitter
    #
    # @return [Time]
    def created_at
      Time.parse(@attrs[:created_at]) if @attrs[:created_at]
    end
    memoize :created_at

    # @return [Boolean]
    def created?
      !!@attrs[:created_at]
    end
    memoize :created?

  end
end
