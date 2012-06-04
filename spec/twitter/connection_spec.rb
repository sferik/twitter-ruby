require 'helper'

describe Twitter::Connection do
  subject do
    client = Twitter::Client.new
    client.class_eval{ public *Twitter::Connection.private_instance_methods }
    client
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      subject.connection.should respond_to(:run_request)
    end

    it "memoizes the connection" do
      c1, c2 = subject.connection, subject.connection
      c1.object_id.should == c2.object_id
    end
  end
end
