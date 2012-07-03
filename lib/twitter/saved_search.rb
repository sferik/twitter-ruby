require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class SavedSearch < Twitter::Identity
    include Twitter::Creatable
    attr_reader :name, :position, :query
  end
end
