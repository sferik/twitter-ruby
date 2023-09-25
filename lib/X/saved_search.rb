require "X/creatable"
require "X/identity"

module X
  class SavedSearch < X::Identity
    include X::Creatable
    # @return [String]
    attr_reader :name, :position, :query
  end
end
