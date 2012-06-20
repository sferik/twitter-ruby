require 'twitter/creatable'
require 'twitter/identifiable'

module Twitter
  class SavedSearch < Twitter::Identifiable
    include Twitter::Creatable
    attr_reader :name, :position, :query
  end
end
