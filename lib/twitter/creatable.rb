require 'time'

module Twitter
  module Creatable

    def created_at
      @created_at ||= Time.parse(@attributes['created_at']) unless @attributes['created_at'].nil?
    end

  end
end
