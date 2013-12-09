require 'equalizer'
require 'twitter/base'

module Twitter
  class Place < Twitter::Base
    attr_reader :attributes, :country, :full_name, :name, :woeid
    alias_method :woe_id, :woeid
    object_attr_reader :GeoFactory, :bounding_box
    object_attr_reader :Place, :contained_within
    alias_method :contained?, :contained_within?
    uri_attr_reader :uri

    # @param other [Twitter::Place]
    # @return [Boolean]
    def eql?(other)
      super || instance_of?(other.class) && !woeid.nil? && other.respond_to?(:woeid) && woeid.eql?(other.woeid)
    end

    # @param other [Twitter::Place]
    # @return [Boolean]
    def ==(other)
      other = coerce(other) if respond_to?(:coerce, true)
      super || kind_of?(self.class) && !woeid.nil? && other.respond_to?(:woeid) && woeid == other.woeid
    end

    # @return [String]
    def country_code
      @attrs[:country_code] || @attrs[:countryCode] # rubocop:disable SymbolName
    end
    memoize :country_code

    # @return [Integer]
    def parent_id
      @attrs[:parentid]
    end
    memoize :parent_id

    # @return [String]
    def place_type
      @attrs[:place_type] || @attrs[:placeType] && @attrs[:placeType][:name] # rubocop:disable SymbolName
    end
    memoize :place_type
  end
end
