require 'helper'

describe Twitter::Error do

  describe "#initialize" do
    it "wraps another error class" do
      begin
        raise Faraday::Error::ClientError.new("Oups")
      rescue Faraday::Error::ClientError => error
        begin
          error.extend(Twitter::Error)
          raise
        rescue Twitter::Error => error
          error.message.should eq "Oups"
          error.class.should eq Faraday::Error::ClientError
        end
      end
    end
  end

end
