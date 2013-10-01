require 'twitter/entity'

module Twitter
  class Entity
    class URI < Twitter::Entity
      uri_attr_reader :expanded_uri, :uri
      display_uri_attr_reader :display_uri
    end

    Uri = URI
    URL = URI
    Url = URI
  end
end
