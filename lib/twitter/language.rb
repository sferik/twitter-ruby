require 'twitter/base'

module Twitter
  class Language < Twitter::Base
    attr_reader :code, :name, :status
  end
end
