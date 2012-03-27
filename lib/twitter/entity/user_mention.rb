require 'twitter/entity'

module Twitter
  class Entity::UserMention < Twitter::Entity
    lazy_attr_reader :screen_name, :name, :id, :id_str
  end
end
