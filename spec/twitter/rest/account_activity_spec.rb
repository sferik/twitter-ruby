require "helper"

describe Twitter::REST::AccountActivity do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe "#create_webhook" do
    context "with a webhook url passed" do
      before do
        stub_post("/2/account_activity/all/env_name/webhooks.json?url=url").with(query: {url: "url"}).to_return(body: fixture("account_activity_create_webhook.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "request create webhook" do
        @client.create_webhook("env_name", "url")
        expect(a_post("/2/account_activity/all/env_name/webhooks.json?url=url").with(body: {})).to have_been_made
      end

      it "returns a webhook response" do
        response = @client.create_webhook("env_name", "url")
        expect(response).to be_a Hash
        expect(response[:id]).to eq("1234567890")
      end
    end
  end

  describe "#list_webhooks" do
    context "list webhooks" do
      before do
        stub_get("/2/account_activity/all/env_name/webhooks.json").to_return(body: fixture("account_activity_list_webhook.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "request list webhooks" do
        @client.list_webhooks("env_name")
        expect(a_get("/2/account_activity/all/env_name/webhooks.json").with(body: {})).to have_been_made
      end

      it "returns a webhook response" do
        response = @client.list_webhooks("env_name")
        expect(response).to be_a Hash
        expect(response[:environments]).to be_a Array
        expect(response[:environments][0][:webhooks]).to be_a Array
        expect(response[:environments][0][:webhooks][0][:id]).to eq("1234567890")
      end
    end
  end

  describe "#trigger_crc_check" do
    context "trigger crc check" do
      before do
        stub_put("/2/account_activity/all/env_name/webhooks/1234567890.json").to_return(status: 204, headers: {content_type: "application/json; charset=utf-8"})
      end

      it "request crc check" do
        @client.trigger_crc_check("env_name", "1234567890")
        expect(a_put("/2/account_activity/all/env_name/webhooks/1234567890.json").with(body: {})).to have_been_made
      end

      it "returns a webhook response" do
        response = @client.trigger_crc_check("env_name", "1234567890")
        expect(response).to eq("")
      end
    end
  end

  describe "#create_subscription" do
    context "create subscription" do
      before do
        stub_post("/2/account_activity/all/env_name/subscriptions.json").to_return(status: 204, headers: {content_type: "application/json; charset=utf-8"})
      end

      it "request create subscription" do
        @client.create_subscription("env_name")
        expect(a_post("/2/account_activity/all/env_name/subscriptions.json").with(body: {})).to have_been_made
      end

      it "returns a webhook response" do
        response = @client.create_subscription("env_name")
        expect(response).to eq("")
      end
    end
  end

  describe "#check_subscription" do
    context "check subscription" do
      before do
        stub_get("/2/account_activity/all/env_name/subscriptions.json").to_return(status: 204, headers: {content_type: "application/json; charset=utf-8"})
      end

      it "request check subscription" do
        @client.check_subscription("env_name")
        expect(a_get("/2/account_activity/all/env_name/subscriptions.json").with(body: {})).to have_been_made
      end

      it "returns a webhook response" do
        response = @client.check_subscription("env_name")
        expect(response).to eq("")
      end
    end
  end

  describe "#delete_webhook" do
    context "delete webhook" do
      before do
        stub_delete("/2/account_activity/all/env_name/webhooks/1234567890.json").to_return(status: 204, headers: {content_type: "application/json; charset=utf-8"})
      end

      it "request delete webhook" do
        @client.delete_webhook("env_name", "1234567890")
        expect(a_delete("/2/account_activity/all/env_name/webhooks/1234567890.json").with(body: {})).to have_been_made
      end

      it "returns a webhook response" do
        response = @client.delete_webhook("env_name", "1234567890")
        expect(response).to eq("")
      end
    end
  end

  describe "#deactivate_subscription" do
    context "deactivate subscription" do
      before do
        stub_delete("/2/account_activity/all/env_name/subscriptions.json").to_return(status: 204, headers: {content_type: "application/json; charset=utf-8"})
      end

      it "request deactivate subscription" do
        @client.deactivate_subscription("env_name")
        expect(a_delete("/2/account_activity/all/env_name/subscriptions.json").with(body: {})).to have_been_made
      end

      it "returns a webhook response" do
        response = @client.deactivate_subscription("env_name")
        expect(response).to eq("")
      end
    end
  end
end
