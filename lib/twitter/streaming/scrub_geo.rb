module Twitter
  module Streaming
    class ScrubGeo < Twitter::Base
      attr_reader :user_id, :up_to_status_id
    end
  end
end
