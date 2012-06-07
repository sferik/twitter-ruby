require 'twitter/base'

module Twitter
  class Entity < Twitter::Base
    attr_reader :indices
  end
end
