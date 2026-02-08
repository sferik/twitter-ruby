require "test_helper"

describe Twitter::Cursor do
  describe "#attrs" do
    before do
      @client = build_rest_client
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
    end

    it "returns the raw attrs hash" do
      cursor = @client.follower_ids("sferik")

      assert_kind_of(Hash, cursor.attrs)
      assert_equal(1_305_102_810_874_389_703, cursor.attrs[:next_cursor])
    end
  end

  describe "with missing key in response" do
    before do
      @client = build_rest_client
      # Response missing the 'ids' key entirely
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: '{"next_cursor":0,"previous_cursor":0}', headers: json_headers)
    end

    it "handles missing key gracefully by treating as empty array" do
      cursor = @client.follower_ids("sferik")

      assert_empty(cursor.to_a)
    end
  end

  describe "#each" do
    before do
      @client = build_rest_client
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "1305102810874389703", screen_name: "sferik"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
    end

    it "requests the correct resources" do
      @client.follower_ids("sferik").each {}

      assert_requested(a_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}))
      assert_requested(a_get("/1.1/followers/ids.json").with(query: {cursor: "1305102810874389703", screen_name: "sferik"}))
    end

    it "iterates" do
      count = 0
      @client.follower_ids("sferik").each { count += 1 }

      assert_equal(6, count)
    end

    it "returns raw IDs (not wrapped in klass) when klass is nil" do
      ids = @client.follower_ids("sferik").to_a

      assert_kind_of(Integer, ids.first)
      assert_equal(20_009_713, ids.first)
    end

    it "returns self to allow chaining" do
      cursor = @client.follower_ids("sferik")

      assert_operator(cursor, :equal?, cursor.each {})
    end

    describe "with start" do
      it "iterates" do
        count = 0
        @client.follower_ids("sferik").each(5) { count += 1 }

        assert_equal(1, count)
      end

      it "returns an enumerator that honors the start argument" do
        enum = @client.follower_ids("sferik").each(5)

        assert_kind_of(Enumerator, enum)
        assert_equal([14_509_199], enum.to_a)
      end
    end
  end

  describe "with klass" do
    before do
      @client = build_rest_client
      stub_get("/1.1/blocks/list.json").with(query: {cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      stub_get("/1.1/blocks/list.json").with(query: {cursor: "1322801608223717003"}).to_return(body: '{"users":[],"next_cursor":0,"previous_cursor":0}', headers: json_headers)
    end

    it "returns instances of the klass" do
      users = @client.blocked.to_a

      assert_kind_of(Twitter::User, users.first)
      assert_kind_of(Integer, users.first.id)
    end
  end

  describe "with limit" do
    before do
      @client = build_rest_client
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "1305102810874389703", screen_name: "sferik"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
    end

    it "stops iterating when limit is reached" do
      count = 0
      @client.follower_ids("sferik", limit: 3).each { count += 1 }
      # First page has 3 items, limit is 3, so exactly the first page
      assert_equal(3, count)
    end

    it "continues to next page when limit is not reached" do
      count = 0
      @client.follower_ids("sferik", limit: 4).each { count += 1 }
      # First page has 3 items, limit is 4, so continue to second page (3 more) = 6 total
      assert_equal(6, count)
    end

    it "stops when limit is less than or equal to accumulated count" do
      count = 0
      # limit:5, page 1 has 3, continue; page 2 adds 3 more = 6 total, 5 <= 6, stop
      @client.follower_ids("sferik", limit: 5).each { count += 1 }

      assert_equal(6, count)
    end

    it "stops when limit is less than accumulated count (not just equal)" do
      count = 0
      # limit:2, page 1 has 3 items, 2 <= 3 = true, stop after first page
      @client.follower_ids("sferik", limit: 2).each { count += 1 }

      assert_equal(3, count)
      # With == instead of <=, 2 == 3 is false, would continue to next page
    end
  end

  describe "#cursor new format" do
    before do
      @client = build_rest_client
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}).to_return(body: fixture("ids_list_new_cursor.json"), headers: json_headers)
      stub_get("/1.1/followers/ids.json").with(query: {cursor: "ODU2NDc3NzEwNTk1NjI0OTYz", screen_name: "sferik"}).to_return(body: fixture("ids_list_new_cursor2.json"), headers: json_headers)
    end

    it "requests the correct resources" do
      @client.follower_ids("sferik").each {}

      assert_requested(a_get("/1.1/followers/ids.json").with(query: {cursor: "-1", screen_name: "sferik"}))
      assert_requested(a_get("/1.1/followers/ids.json").with(query: {cursor: "ODU2NDc3NzEwNTk1NjI0OTYz", screen_name: "sferik"}))
    end

    it "iterates" do
      count = 0
      @client.follower_ids("sferik").each { count += 1 }

      assert_equal(6, count)
    end

    describe "with start" do
      it "iterates" do
        count = 0
        @client.follower_ids("sferik").each(5) { count += 1 }

        assert_equal(1, count)
      end

      it "returns an enumerator that honors the start argument" do
        enum = @client.follower_ids("sferik").each(5)

        assert_kind_of(Enumerator, enum)
        assert_equal([351_223_419], enum.to_a)
      end
    end
  end

  describe "private cursor behavior" do
    it "can be initialized without an explicit limit argument" do
      request = Object.new
      request.define_singleton_method(:client) { Object.new }
      request.define_singleton_method(:verb) { :get }
      request.define_singleton_method(:path) { "/1.1/followers/ids.json" }
      request.define_singleton_method(:options) { {} }
      request.define_singleton_method(:perform) { {ids: [], next_cursor: 0} }

      assert_nothing_raised { Twitter::Cursor.new(:ids, nil, request) }
    end

    it "treats String subclasses as cursor strings in #last?" do
      cursor = Twitter::Cursor.allocate
      string_subclass = Class.new(String)
      cursor.instance_variable_set(:@attrs, {next_cursor: string_subclass.new("abc")})

      refute(cursor.send(:last?))
    end

    it "uses hash defaults when checking reached limits" do
      cursor = Twitter::Cursor.allocate
      attrs = Hash.new { |_hash, _key| [1, 2, 3] }
      cursor.instance_variable_set(:@attrs, attrs)
      cursor.instance_variable_set(:@limit, 2)
      cursor.instance_variable_set(:@key, :ids)

      assert(cursor.send(:reached_limit?))
    end
  end
end
