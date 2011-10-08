require 'time'

module Twitter
  module Creatable
    # Time when the user was created
    #
    # @return [Time]
    def created_at
      Time.parse(@created_at) if @created_at
    end
  end
end
