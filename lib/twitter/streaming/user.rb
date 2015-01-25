module Twitter
  module Streaming
    class User < Twitter::Base
      attr_reader :id, :name, :dm
    end
  end
end
