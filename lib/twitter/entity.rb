require 'twitter/base'

module Twitter
  class Entity < Twitter::Base
    lazy_attr_reader :indices
  end
end
