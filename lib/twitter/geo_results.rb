require 'twitter/enumerable'

module Twitter
  class GeoResults
    include Twitter::Enumerable
    attr_reader :attrs
    alias to_h attrs
    alias to_hash attrs
    alias to_hsh attrs

    # Construct a new SearchResults object from a response hash
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def self.from_response(response={})
      new(response[:body])
    end

    # Initializes a new SearchResults object
    #
    # @param attrs [Hash]
    # @return [Twitter::GeoResults]
    def initialize(attrs={})
      @attrs = attrs
      @collection = Array(@attrs[:result][:places]).map do |place|
        Twitter::Place.new(place)
      end
    end

    # @return [String]
    def token
      @attrs[:token]
    end

  end
end
