require "X/entity"

module X
  class Entity
    class URI < X::Entity
      display_uri_attr_reader
      uri_attr_reader :expanded_uri, :uri
    end
  end
end
