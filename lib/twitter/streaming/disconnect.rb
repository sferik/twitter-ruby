module Twitter
  module Streaming
    class Disconnect < Twitter::Base
      attr_reader :code, :stream_name, :reason
    end
  end
end
