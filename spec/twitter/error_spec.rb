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
          expect(error.message).to eq "Oups"
          expect(error.wrapped_exception.class).to eq Faraday::Error::ClientError
        end
      end
    end
  end

end
