require "X/entity"

module X
  class Entity
    class Symbol < X::Entity
      # @return [String]
      attr_reader :text
    end
  end
end
