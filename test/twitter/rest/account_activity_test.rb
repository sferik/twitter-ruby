require "test_helper"

describe Twitter::REST::AccountActivity do
  before do
    @client = build_rest_client
  end

  describe "#create_webhook" do
    describe "with a webhook url passed" do
      before do
        stub_post("/1.1/account_activity/all/env_name/webhooks.json?url=url").with(query: {url: "url"}).to_return(body: fixture("account_activity_create_webhook.json"), headers: json_headers)
      end

      it "request create webhook" do
        @client.create_webhook("env_name", "url")

        assert_requested(a_post("/1.1/account_activity/all/env_name/webhooks.json?url=url").with(body: {}))
      end

      it "returns a webhook response" do
        response = @client.create_webhook("env_name", "url")

        assert_kind_of(Hash, response)
        assert_equal("1234567890", response[:id])
      end
    end
  end

  describe "#list_webhooks" do
    describe "list webhooks" do
      before do
        stub_get("/1.1/account_activity/all/env_name/webhooks.json").to_return(body: fixture("account_activity_list_webhook.json"), headers: json_headers)
      end

      it "request list webhooks" do
        @client.list_webhooks("env_name")

        assert_requested(a_get("/1.1/account_activity/all/env_name/webhooks.json").with(body: {}))
      end

      it "returns a webhook response" do
        response = @client.list_webhooks("env_name")

        assert_kind_of(Hash, response)
        assert_kind_of(Array, response[:environments])
        assert_kind_of(Array, response[:environments][0][:webhooks])
        assert_equal("1234567890", response[:environments][0][:webhooks][0][:id])
      end
    end
  end

  describe "#trigger_crc_check" do
    describe "trigger crc check" do
      before do
        stub_put("/1.1/account_activity/all/env_name/webhooks/1234567890.json").to_return(status: 204, headers: json_headers)
      end

      it "request crc check" do
        @client.trigger_crc_check("env_name", "1234567890")

        assert_requested(a_put("/1.1/account_activity/all/env_name/webhooks/1234567890.json").with(body: {}))
      end

      it "returns a webhook response" do
        response = @client.trigger_crc_check("env_name", "1234567890")

        assert_equal("", response)
      end
    end
  end

  describe "#create_subscription" do
    describe "create subscription" do
      before do
        stub_post("/1.1/account_activity/all/env_name/subscriptions.json").to_return(status: 204, headers: json_headers)
      end

      it "request create subscription" do
        @client.create_subscription("env_name")

        assert_requested(a_post("/1.1/account_activity/all/env_name/subscriptions.json").with(body: {}))
      end

      it "returns a webhook response" do
        response = @client.create_subscription("env_name")

        assert_equal("", response)
      end
    end
  end

  describe "#check_subscription" do
    describe "check subscription" do
      before do
        stub_get("/1.1/account_activity/all/env_name/subscriptions.json").to_return(status: 204, headers: json_headers)
      end

      it "request check subscription" do
        @client.check_subscription("env_name")

        assert_requested(a_get("/1.1/account_activity/all/env_name/subscriptions.json").with(body: {}))
      end

      it "returns a webhook response" do
        response = @client.check_subscription("env_name")

        assert_equal("", response)
      end
    end
  end

  describe "#delete_webhook" do
    describe "delete webhook" do
      before do
        stub_delete("/1.1/account_activity/all/env_name/webhooks/1234567890.json").to_return(status: 204, headers: json_headers)
      end

      it "request delete webhook" do
        @client.delete_webhook("env_name", "1234567890")

        assert_requested(a_delete("/1.1/account_activity/all/env_name/webhooks/1234567890.json").with(body: {}))
      end

      it "returns a webhook response" do
        response = @client.delete_webhook("env_name", "1234567890")

        assert_equal("", response)
      end
    end
  end

  describe "#deactivate_subscription" do
    describe "deactivate subscription" do
      before do
        stub_delete("/1.1/account_activity/all/env_name/subscriptions.json").to_return(status: 204, headers: json_headers)
      end

      it "request deactivate subscription" do
        @client.deactivate_subscription("env_name")

        assert_requested(a_delete("/1.1/account_activity/all/env_name/subscriptions.json").with(body: {}))
      end

      it "returns a webhook response" do
        response = @client.deactivate_subscription("env_name")

        assert_equal("", response)
      end
    end
  end
end
