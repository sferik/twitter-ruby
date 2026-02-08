require "test_helper"

describe Twitter::REST::SpamReporting do
  before do
    @client = build_rest_client
  end

  describe "#report_spam" do
    before do
      stub_post("/1.1/users/report_spam.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.report_spam("sferik")

      assert_requested(a_post("/1.1/users/report_spam.json").with(body: {screen_name: "sferik"}))
    end

    it "returns an array of users" do
      users = @client.report_spam("sferik")

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
      assert_equal(7_505_382, users.first.id)
    end
  end
end
