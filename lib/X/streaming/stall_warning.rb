module X
  module Streaming
    class StallWarning < X::Base
      attr_reader :code, :message, :percent_full
    end
  end
end
