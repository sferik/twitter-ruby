require "twitter/entity"

module Twitter
  class Entity
    # Represents a URI entity in a tweet
    class URI < Entity
      display_uri_attr_reader
      uri_attr_reader :expanded_uri, :uri
    end
  end
end
