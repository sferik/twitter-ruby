require 'twitter/base'
require 'twitter/creatable'

module Twitter
  class Action < Twitter::Base
    include Twitter::Creatable
    lazy_attr_reader :max_position, :min_position
  end
end
