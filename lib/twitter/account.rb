require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  # TODO: Identity is documented as being an int. I have a string id.
  class Account < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :salt, :approval_status, :timezone, :timezone_switch_at

    alias_method :time_zone, :timezone
    alias_method :time_zone_switch_at, :timezone_switch_at

    predicate_attr_reader :deleted

    # @return [Boolean]
    def approved?
      approval_status == 'ACCEPTED'
    end
    memoize :approved?
  end
end
