require "X/entity"

module X
  class Entity
    class Hashtag < X::Entity
      # @return [String]
      attr_reader :text
    end
  end
end
