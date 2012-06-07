require 'twitter/base'

module Twitter
  class Metadata < Twitter::Base
    attr_reader :result_type
  end
end
