require 'twitter/base'

module Twitter
  class Language < Twitter::Base
    lazy_attr_reader :code, :name, :status
  end
end
