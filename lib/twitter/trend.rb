require 'twitter/base'

module Twitter
  class Trend < Twitter::Base
    attr_reader :events, :name, :promoted_content, :query, :url

    # @param other [Twitter::Trend]
    # @return [Boolean]
    def ==(other)
      super || self.name_equal(other) || self.attrs_equal(other)
    end

  protected

    # @param other [Twitter::Trend]
    # @return [Boolean]
    def name_equal(other)
      self.class == other.class && !other.name.nil? && self.name == other.name
    end

  end
end
