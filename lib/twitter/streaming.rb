require 'buftok'
require 'celluloid/io'
require 'http/parser'
require 'openssl'
require 'resolv'

require 'twitter/streaming/connection'
require 'twitter/streaming/proxy'
require 'twitter/streaming/request'
require 'twitter/streaming/response'
require 'twitter/streaming/stream'

module Twitter
  module Streaming

    def stream
      @stream ||= Twitter::Streaming::Stream.new(self)
    end

  end
end
