require 'helper'

describe Twitter::Error do

  describe "#initialize" do
    it "wraps another error class" do
      begin
        raise Faraday::Error::ClientError.new("Oops")
      rescue Faraday::Error::ClientError
        begin
          raise Twitter::Error
        rescue Twitter::Error => error
          expect(error.message).to eq "Oops"
          expect(error.wrapped_exception.class).to eq Faraday::Error::ClientError
        end
      end
    end
  end

  describe ".descendants" do
    it "Finds descendants of Twitter::Error" do
      class ComparableObject
        extend ::Comparable
      end
      expect(Twitter::Error.descendants).to include Twitter::Error::GatewayTimeout
    end
  end

end
