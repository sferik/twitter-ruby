require 'time'

module Twitter
  module Creatable

    # Time when the object was created on Twitter
    #
    # @return [String]
    def created_at
      @created_at ||= @attrs['created_at'] unless @attrs['created_at'].nil?
    end

  end
end
