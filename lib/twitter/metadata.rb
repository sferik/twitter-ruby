require 'twitter/base'

module Twitter
  class Metadata < Twitter::Base
    lazy_attr_reader :result_type
  end
end
