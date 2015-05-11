require 'twitter/identity'

module Twitter
  class TailoredAudienceChange < Twitter::Identity
    # @return [String]
    attr_reader :input_file, :operation, :state, :tailored_audience_id

    def completed?
      self.state == 'COMPLETED'
    end
  end
end
