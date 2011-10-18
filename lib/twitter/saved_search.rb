require 'twitter/base'
require 'twitter/creatable'

module Twitter
  class SavedSearch < Twitter::Base
    include Twitter::Creatable
    attr_reader :id, :name, :position, :query

    def ==(other)
      super || (other.class == self.class && other.instance_variable_get('@id'.to_sym) == @id)
    end

  end
end
