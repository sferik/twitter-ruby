require 'helper'

describe Twitter::Requestable do
  subject do
    client = Twitter::Client.new
    client.class_eval{ public *Twitter::Requestable.private_instance_methods }
    client
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      subject.connection.should respond_to(:run_request)
    end
    it "memoizes the connection" do
      c1, c2 = subject.connection, subject.connection
      c1.object_id.should eq c2.object_id
    end
  end

  describe "#request" do
    before do
      subject.stub!(:connection).and_raise(Faraday::Error::ClientError.new("Oups"))
    end
    it "catches Faraday errors" do
      lambda do
        subject.request(:get, "/path", {}, {})
      end.should raise_error(Twitter::Error::ClientError, "Oups")
    end
  end

end
