require 'time'

module Twitter
  module Creatable

    # Time when the object was created on Twitter
    #
    # @return [Time]
    def created_at
      @created_at ||= Time.parse(@attrs[:created_at]) if created_at?
    end

    def created_at?
      !@attrs[:created_at].nil?
    end

  end
end
