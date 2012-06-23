require 'helper'

describe Twitter::Error do

  describe "#initialize" do
    it "wraps another error class" do
      begin
        raise Faraday::Error::ClientError.new("Oups")
      rescue Faraday::Error::ClientError
        begin
          raise Twitter::Error
        rescue Twitter::Error => error
          error.message.should eq "Oups"
          error.wrapped_exception.class.should eq Faraday::Error::ClientError
        end
      end
    end
  end

end
