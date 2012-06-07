require 'twitter/entity'

module Twitter
  class Entity::Hashtag < Twitter::Entity
    attr_reader :text
  end
end
