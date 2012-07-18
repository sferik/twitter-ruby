require 'twitter/entity'

module Twitter
  class Entity
    class UserMention < Twitter::Entity
      attr_reader :id, :name, :screen_name
    end
  end
end
