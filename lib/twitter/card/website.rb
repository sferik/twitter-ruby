require 'twitter/card'

module Twitter
  class Card
    class Website < Twitter::Card
      # @return [String]
      attr_reader :website_cta, :website_title

      # @return [String]
      attr_reader :website_url
    end
  end
end
