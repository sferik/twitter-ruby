require 'twitter/creatable'
require 'twitter/identifiable'

module Twitter
  class SavedSearch < Twitter::Identifiable
    include Twitter::Creatable
        attr_reader :name, :position, :query

    # @param other [Twitter::SavedSearch]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
