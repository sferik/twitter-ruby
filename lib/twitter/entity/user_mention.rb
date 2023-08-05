require "twitter/entity"

module Twitter
  class Entity
    class UserMention < Twitter::Entity
      # @return [Integer]
      attr_reader :id
      # @return [String]
      attr_reader :name, :username
    end
  end
end
