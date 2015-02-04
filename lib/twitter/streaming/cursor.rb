module Twitter
  module Streaming
    class Cursor < Twitter::Cursor
      include Memoizable

      # Initializes a new Cursor
      #
      # @param key [String, Symbol] The key to fetch the data from the response
      # @param klass [Class] The class to instantiate objects in the response
      # @param request [Twitter::REST::Request]
      # @return [Twitter::Cursor]
      def initialize(key, klass, request, parent_key = nil)
        @parent_key = parent_key.to_sym if parent_key
        super(key, klass, request)
      end

      # Return the user info.
      #
      # @return [Array<Twitter::Streaming::User>]
      def user
        Twitter::Streaming::User.new(@attrs[:user]) if @attrs[:user]
      end
      memoize :user

    private

      # @param attrs [Hash]
      # @return [Hash]
      def attrs=(attrs)
        @attrs = attrs.fetch(@parent_key)
        @attrs.fetch(@key, []).each do |element|
          @collection << (@klass ? @klass.new(element) : element)
        end
        @attrs
      end
    end
  end
end
