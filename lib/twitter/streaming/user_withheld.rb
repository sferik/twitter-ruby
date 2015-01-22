module Twitter
  module Streaming
    class UserWithheld < Twitter::Base
      attr_reader :id, :withheld_in_countries
    end
  end
end
