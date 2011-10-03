require 'faraday'
require 'hashie/mash'

module Twitter
  module Response
    class Mashify < Faraday::Response::Middleware

      class << self
        attr_accessor :mash_class
      end

      self.mash_class = ::Hashie::Mash

      def parse(body)
        case body
        when Hash
          self.class.mash_class.new(body)
        when Array
          body.map { |item| item.is_a?(Hash) ? self.class.mash_class.new(item) : item }
        else
          body
        end
      end
    end
  end
end
