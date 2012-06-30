require 'twitter/base'

module Twitter
  class Trend < Twitter::Base
    attr_reader :events, :name, :promoted_content, :query, :url

    # @param other [Twitter::Trend]
    # @return [Boolean]
    def ==(other)
      super || self.attr_equal(:name, other) || self.attrs_equal(other)
    end

  end
end
