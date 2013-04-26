require 'twitter/entity'

module Twitter
  class Entity
    class Symbol < Twitter::Entity
      attr_reader :text
    end
  end
end
