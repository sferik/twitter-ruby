require 'twitter/creatable'
require 'twitter/identifiable'

module Twitter
  class SavedSearch < Twitter::Identifiable
    include Twitter::Creatable
    lazy_attr_reader :name, :position, :query

    # @param other [Twiter::SavedSearch]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
