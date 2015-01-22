module Twitter
  module Streaming
    class StatusWithheld < Twitter::Base
      attr_reader :id, :user_id, :withheld_in_countries
    end
  end
end
