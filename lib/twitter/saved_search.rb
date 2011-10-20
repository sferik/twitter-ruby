require 'twitter/base'
require 'twitter/creatable'

module Twitter
  class SavedSearch < Twitter::Base
    include Twitter::Creatable
    lazy_attr_reader :id, :name, :position, :query

    # @param other [Twiter::SavedSearch]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
