require "X/entity"

module X
  class Entity
    class UserMention < X::Entity
      # @return [Integer]
      attr_reader :id
      # @return [String]
      attr_reader :name, :screen_name
    end
  end
end
