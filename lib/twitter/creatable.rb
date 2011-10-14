require 'time'

module Twitter
  module Creatable
    # Time when the user was created
    #
    # @return [Time]
    def created_at
      @created_at = Time.parse(@created_at) unless @created_at.nil? || @created_at.is_a?(Time)
    end
  end
end
