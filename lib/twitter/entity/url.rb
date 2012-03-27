require 'twitter/entity'

module Twitter
  class Entity::Url < Twitter::Entity
    lazy_attr_reader :display_url, :expanded_url, :url
  end
end
