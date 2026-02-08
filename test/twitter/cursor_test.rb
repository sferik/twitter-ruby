require "helper"

describe Twitter::Cursor do
  describe "#attrs" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "returns the raw attrs hash" do
      cursor = @client.follower_ids("sferik")
      expect(cursor.attrs).to be_a(Hash)
      expect(cursor.attrs[:next_cursor]).to eq(1_305_102_810_874_389_703)
    end
  end

  describe "with missing key in response" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      # Response missing the 'ids' key entirely
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: '{"next_cursor":0,"previous_cursor":0}', headers: {content_type: "application/json; charset=utf-8"})
    end

    it "handles missing key gracefully by treating as empty array" do
      cursor = @client.follower_ids("sferik")
      expect(cursor.to_a).to eq([])
    end
  end

  describe "#each" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "1305102810874389703", screen_name: "sferik"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resources" do
      @client.follower_ids("sferik").each {}
      expect(a_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"})).to have_been_made
      expect(a_get("/1.1/followers/ids.json").with(query: {cursor: "1305102810874389703", screen_name: "sferik"})).to have_been_made
    end

    it "iterates" do
      count = 0
      @client.follower_ids("sferik").each { count += 1 }
      expect(count).to eq(6)
    end

    it "returns raw IDs (not wrapped in klass) when klass is nil" do
      ids = @client.follower_ids("sferik").to_a
      expect(ids.first).to be_an(Integer)
      expect(ids.first).to eq(20_009_713)
    end

    it "returns self to allow chaining" do
      cursor = @client.follower_ids("sferik")
      expect(cursor.each {}).to be(cursor)
    end

    context "with start" do
      it "iterates" do
        count = 0
        @client.follower_ids("sferik").each(5) { count += 1 }
        expect(count).to eq(1)
      end

      it "returns an enumerator that honors the start argument" do
        enum = @client.follower_ids("sferik").each(5)
        expect(enum).to be_an(Enumerator)
        expect(enum.to_a).to eq([14_509_199])
      end
    end
  end

  describe "with klass" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      stub_get("/1.1/blocks/list.json").with(query: {cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/blocks/list.json").with(query: {cursor: "1322801608223717003"}).to_return(body: '{"users":[],"next_cursor":0,"previous_cursor":0}', headers: {content_type: "application/json; charset=utf-8"})
    end

    it "returns instances of the klass" do
      users = @client.blocked.to_a
      expect(users.first).to be_a(Twitter::User)
      expect(users.first.id).to be_an(Integer)
    end
  end

  describe "with limit" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "1305102810874389703", screen_name: "sferik"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "stops iterating when limit is reached" do
      count = 0
      @client.follower_ids("sferik", limit: 3).each { count += 1 }
      # First page has 3 items, limit is 3, so exactly the first page
      expect(count).to eq(3)
    end

    it "continues to next page when limit is not reached" do
      count = 0
      @client.follower_ids("sferik", limit: 4).each { count += 1 }
      # First page has 3 items, limit is 4, so continue to second page (3 more) = 6 total
      expect(count).to eq(6)
    end

    it "stops when limit is less than or equal to accumulated count" do
      count = 0
      # limit:5, page 1 has 3, continue; page 2 adds 3 more = 6 total, 5 <= 6, stop
      @client.follower_ids("sferik", limit: 5).each { count += 1 }
      expect(count).to eq(6)
    end

    it "stops when limit is less than accumulated count (not just equal)" do
      count = 0
      # limit:2, page 1 has 3 items, 2 <= 3 = true, stop after first page
      @client.follower_ids("sferik", limit: 2).each { count += 1 }
      expect(count).to eq(3)
      # With == instead of <=, 2 == 3 is false, would continue to next page
    end
  end

  describe "#cursor new format" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list_new_cursor.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "ODU2NDc3NzEwNTk1NjI0OTYz", screen_name: "sferik"}).to_return(body: fixture("ids_list_new_cursor2.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resources" do
      @client.follower_ids("sferik").each {}
      expect(a_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"})).to have_been_made
      expect(a_get("/1.1/followers/ids.json").with(query: {cursor: "ODU2NDc3NzEwNTk1NjI0OTYz", screen_name: "sferik"})).to have_been_made
    end

    it "iterates" do
      count = 0
      @client.follower_ids("sferik").each { count += 1 }
      expect(count).to eq(6)
    end

    context "with start" do
      it "iterates" do
        count = 0
        @client.follower_ids("sferik").each(5) { count += 1 }
        expect(count).to eq(1)
      end

      it "returns an enumerator that honors the start argument" do
        enum = @client.follower_ids("sferik").each(5)
        expect(enum).to be_an(Enumerator)
        expect(enum.to_a).to eq([351_223_419])
      end
    end
  end

  describe "private cursor behavior" do
    it "can be initialized without an explicit limit argument" do
      request = instance_double(
        Twitter::REST::Request,
        client: double("client"),
        verb: :get,
        path: "/1.1/followers/ids.json",
        options: {},
        perform: {ids: [], next_cursor: 0}
      )

      expect { described_class.new(:ids, nil, request) }.not_to raise_error
    end

    it "treats String subclasses as cursor strings in #last?" do
      cursor = described_class.allocate
      string_subclass = Class.new(String)
      cursor.instance_variable_set(:@attrs, {next_cursor: string_subclass.new("abc")})

      expect(cursor.send(:last?)).to be(false)
    end

    it "uses hash defaults when checking reached limits" do
      cursor = described_class.allocate
      attrs = Hash.new { |_hash, _key| [1, 2, 3] }
      cursor.instance_variable_set(:@attrs, attrs)
      cursor.instance_variable_set(:@limit, 2)
      cursor.instance_variable_set(:@key, :ids)

      expect(cursor.send(:reached_limit?)).to be(true)
    end
  end
end
