require "X/base"

module X
  class OEmbed < X::Base
    # @return [Integer]
    attr_reader :height, :width
    # @return [String]
    attr_reader :author_name, :cache_age, :html, :provider_name, :type,
                :version

    uri_attr_reader :author_uri, :provider_uri, :uri
  end
end
