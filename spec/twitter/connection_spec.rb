require 'helper'

describe Twitter::Connection do
  subject do
    client = Twitter::Client.new
    client.class_eval{ public *Twitter::Connection.private_instance_methods }
    client
  end

  describe "#connection" do
    let(:endpoint){ URI.parse("https://api.tweeter.com") }

    it "returns a Faraday connection" do
      subject.connection.should be_a(Faraday::Connection)
    end

    it "memoizes the connection" do
      c1, c2 = subject.connection, subject.connection
      c1.object_id.should == c2.object_id
    end

    it "optionally sets a custom endpoint" do
      connection = subject.connection(:endpoint => endpoint)
      connection.url_prefix.should == endpoint
    end

    it "memoizes connections, respecting different options" do
      c1, c2 = subject.connection(:endpoint => endpoint), subject.connection
      c1.object_id.should_not == c2.object_id
      c3 = subject.connection(:endpoint => endpoint)
      c3.object_id.should == c1.object_id
    end
  end
end
