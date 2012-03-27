require 'twitter/entity'

module Twitter
  class Entity::Hashtag < Twitter::Entity
    lazy_attr_reader :text
  end
end
