require 'twitter/entity'

module Twitter
  class Entity
    class Hashtag < Twitter::Entity
      attr_reader :text
    end
  end
end
