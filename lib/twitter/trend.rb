require 'twitter/base'

module Twitter
  class Trend < Twitter::Base
    attr_reader :events, :name, :promoted_content, :query, :url

    def ==(other)
      super || (other.class == self.class && other.name == self.name)
    end
  end
end
