require 'twitter/cursor'

module Twitter
  class Request
    attr_accessor :client, :request_method, :path, :options
    alias_method :verb, :request_method

    # @param client [Twitter::Client]
    # @param request_method [String, Symbol]
    # @param path [String]
    # @param options [Hash]
    # @return [Twitter::Request]
    def initialize(client, request_method, path, options = {})
      @client = client
      @request_method = request_method.to_sym
      @path = path
      @options = options
    end

    # @return [Hash]
    def perform
      @client.send(@request_method, @path, @options).body
    end

    # @param klass [Class]
    # @param request [Twitter::Request]
    # @return [Object]
    def perform_with_object(klass)
      klass.new(perform)
    end

    # @param collection_name [Symbol]
    # @param klass [Class]
    # @return [Twitter::Cursor]
    def perform_with_cursor(collection_name, klass = nil)
      Twitter::Cursor.new(perform, collection_name.to_sym, klass, self)
    end

    # @param klass [Class]
    # @return [Array]
    def perform_with_objects(klass)
      perform.collect do |element|
        klass.new(element)
      end
    end
  end
end
