require 'twitter/base'
require 'twitter/creatable'

module Twitter
  class SavedSearch < Twitter::Base
    include Twitter::Creatable
    attr_reader :id, :name, :position, :query

    def ==(other)
      super || (other.class == self.class && other.id == @id)
    end
  end
end
