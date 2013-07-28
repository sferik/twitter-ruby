require 'twitter/base'

module Twitter
  class Trend < Twitter::Base
    attr_reader :events, :name, :promoted_content, :query

    # @param other [Twitter::Trend]
    # @return [Boolean]
    def ==(other)
      super || attr_equal(:name, other) || attrs_equal(other)
    end

    # @return [URI] The URI to the trend.
    def uri
      @uri ||= ::URI.parse(@attrs[:url]) if uri?
    end
    alias url uri

    # @return [Boolean]
    def uri?
      !!@attrs[:url]
    end
    alias url? uri?

  end
end
