require 'time'

module Twitter
  module Creatable

    def created_at
      @created_at ||= Time.parse(@attrs['created_at']) unless @attrs['created_at'].nil?
    end

  end
end
