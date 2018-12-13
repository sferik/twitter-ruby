require 'twitter/creatable'
require 'twitter/entities'
require 'twitter/identity'

module Twitter
  class WelcomeMessage < Twitter::Identity
    include Twitter::Creatable
    include Twitter::Entities
    # @return [String]
    attr_reader :text
    # @return [String]
    attr_reader :name
    alias full_text text
  end
end
