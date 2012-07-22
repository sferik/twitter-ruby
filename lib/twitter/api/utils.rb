require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/core_ext/hash'
require 'twitter/user'

module Twitter
  module API
    module Utils
    private

      def collection_from_array(array, klass)
        array.map do |element|
          klass.fetch_or_new(element)
        end
      end

      def users_from_response(method, url, args)
        options = args.extract_options!
        args.flatten.threaded_map do |user|
          response = self.send(method, url, options.merge_user(user))
          Twitter::User.from_response(response)
        end
      end

    end
  end
end
