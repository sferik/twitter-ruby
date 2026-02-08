require "test_helper"

describe Twitter::Base do
  before do
    @base = Twitter::Base.new(id: 1)
  end

  describe "#[]" do
    it "calls methods using [] with symbol" do
      capture_warning do
        assert_kind_of(Integer, @base[:object_id])
      end
    end

    it "calls methods using [] with string" do
      capture_warning do
        assert_kind_of(Integer, @base["object_id"])
      end
    end

    it "returns nil for missing method" do
      capture_warning do
        assert_nil(@base[:foo])
        assert_nil(@base["foo"])
      end
    end

    it "emits a deprecation warning with caller info and method name" do
      warning = capture_warning { @base[:object_id] }

      assert_includes(warning, "[DEPRECATION]")
      assert_includes(warning, ":object_id")
      assert_includes(warning, "Use #object_id")
      assert_match(/\.rb:\d+:/, warning) # caller location format with path:lineno:
    end

    it "calls caller_locations with exactly one caller frame" do
      location = Object.new
      location.define_singleton_method(:path) { "spec/file.rb" }
      location.define_singleton_method(:lineno) { 123 }
      location.define_singleton_method(:to_s) { "sentinel" }
      warning = nil

      @base.stub(:caller_locations, lambda { |start, count|
        assert_equal(1, start)
        assert_equal(1, count)
        [location]
      }) do
        warning = capture_warning { @base[:object_id] }
      end

      assert_equal("spec/file.rb:123: [DEPRECATION] #[:object_id] is deprecated. Use #object_id to fetch the value.\n", warning)
    end

    it "supports any method-like object that responds to to_sym" do
      method_name = Object.new
      method_name.define_singleton_method(:to_sym) { :object_id }

      capture_warning do
        assert_kind_of(Integer, @base[method_name])
      end
    end

    it "does not raise when caller location is nil" do
      warning = nil
      @base.stub(:caller_locations, lambda { |start, count|
        assert_equal(1, start)
        assert_equal(1, count)
        [nil]
      }) do
        warning = capture_warning do
          assert_kind_of(Integer, @base[:object_id])
        end
      end

      assert_includes(warning, "[DEPRECATION]")
    end

    it "still works when caller_locations itself returns nil" do
      @base.stub(:caller_locations, lambda { |start, count|
        assert_equal(1, start)
        assert_equal(1, count)
        nil
      }) do
        capture_warning do
          assert_kind_of(Integer, @base[:object_id])
        end
      end
    end
  end

  describe "#attrs" do
    it "returns a hash of attributes" do
      assert_equal({id: 1}, @base.attrs)
    end
  end

  describe "#initialize" do
    it "converts nil to empty hash" do
      base = Twitter::Base.new(nil)

      assert_empty(base.attrs)
    end

    it "works with no arguments (defaults to empty hash)" do
      base = Twitter::Base.new

      assert_empty(base.attrs)
    end

    it "uses the provided hash directly" do
      attrs = {id: 42}
      base = Twitter::Base.new(attrs)

      assert_equal({id: 42}, base.attrs)
    end
  end

  describe ".attr_reader" do
    let(:example_class) do
      Class.new(Twitter::Base) do
        attr_reader :name, :tags
      end
    end

    it "defines an attribute reader method" do
      obj = example_class.new(name: "test")

      assert_equal("test", obj.name)
    end

    it "defines a predicate method" do
      obj = example_class.new(name: "test")

      assert_predicate(obj, :name?)
    end

    it "returns NullObject when attribute is missing" do
      obj = example_class.new({})

      assert_kind_of(Twitter::NullObject, obj.name)
    end

    it "returns false from predicate when attribute is missing" do
      obj = example_class.new({})

      refute_predicate(obj, :name?)
    end

    it "treats explicit nil as falsey (key exists but value is nil)" do
      obj = example_class.new(name: nil)

      refute_predicate(obj, :name?)
      assert_kind_of(Twitter::NullObject, obj.name)
    end

    it "returns NullObject when attribute is empty array" do
      obj = example_class.new(tags: [])

      assert_kind_of(Twitter::NullObject, obj.tags)
    end

    it "returns false from predicate when attribute is empty" do
      obj = example_class.new(tags: [])

      refute_predicate(obj, :tags?)
    end

    it "returns the array when it has items" do
      obj = example_class.new(tags: ["ruby"])

      assert_equal(["ruby"], obj.tags)
      assert_predicate(obj, :tags?)
    end

    it "memoizes the attribute value" do
      obj = example_class.new(name: "test")
      first_call = obj.name
      second_call = obj.name

      assert_operator(second_call, :equal?, first_call)
    end

    it "memoizes the predicate value" do
      obj = example_class.new(name: "test")
      first_call = obj.name?
      second_call = obj.name?

      assert_equal(second_call, first_call)
    end

    it "memoizes values even when [] returns a fresh object each time" do
      volatile_attrs_class = Class.new do
        def [](_key)
          Object.new
        end
      end
      obj = example_class.new(volatile_attrs_class.new)

      assert_operator(obj.name, :equal?, obj.name)
    end

    it "uses [] access for attribute value lookup (not fetch)" do
      attrs_class = Class.new do
        def [](_key)
          "value-from-brackets"
        end

        def fetch(_key)
          raise KeyError, "fetch should not be used"
        end
      end
      obj = example_class.new(attrs_class.new)

      assert_equal("value-from-brackets", obj.name)
    end

    it "memoizes predicate values even when backing attrs change" do
      attrs = {name: "present"}
      obj = example_class.new(attrs)

      assert_predicate(obj, :name?)

      attrs[:name] = nil

      assert_predicate(obj, :name?)
    end
  end

  describe ".predicate_attr_reader" do
    let(:example_class) do
      Class.new(Twitter::Base) do
        predicate_attr_reader :active
      end
    end

    it "defines a predicate method" do
      obj = example_class.new(active: true)

      assert_predicate(obj, :active?)
    end

    it "returns false when attribute is missing" do
      obj = example_class.new({})

      refute_predicate(obj, :active?)
    end
  end

  describe ".uri_attr_reader" do
    let(:example_class) do
      Class.new(Twitter::Base) do
        uri_attr_reader :profile_uri
      end
    end

    it "defines a URI method that parses the URL attribute" do
      obj = example_class.new(profile_url: "https://example.com/profile")

      assert_kind_of(Addressable::URI, obj.profile_uri)
      assert_equal("https://example.com/profile", obj.profile_uri.to_s)
    end

    it "aliases the url method" do
      obj = example_class.new(profile_url: "https://example.com/profile")

      assert_equal(obj.profile_uri, obj.profile_url)
    end

    it "returns nil when URL attribute is missing" do
      obj = example_class.new({})

      assert_nil(obj.profile_uri)
    end

    it "defines predicate methods for both uri and url" do
      obj = example_class.new(profile_url: "https://example.com")

      assert_predicate(obj, :profile_uri?)
      assert_predicate(obj, :profile_url?)
    end

    it "strips trailing # from URLs" do
      obj = example_class.new(profile_url: "https://example.com#")

      assert_equal("https://example.com", obj.profile_uri.to_s)
    end

    it "memoizes the URI value" do
      obj = example_class.new(profile_url: "https://example.com")
      first_call = obj.profile_uri
      second_call = obj.profile_uri

      assert_operator(second_call, :equal?, first_call)
    end

    it "uses [] for uri lookup (not fetch)" do
      attrs_class = Class.new do
        def [](_key)
          "https://example.com/profile#"
        end

        def fetch(_key)
          raise KeyError, "fetch should not be used"
        end
      end
      obj = example_class.new(attrs_class.new)

      assert_equal("https://example.com/profile", obj.profile_uri.to_s)
    end
  end

  describe ".object_attr_reader" do
    let(:example_class) do
      Class.new(Twitter::Base) do
        object_attr_reader :Place, :place
      end
    end

    it "defines a method that returns an object of the specified class" do
      obj = example_class.new(place: {name: "NYC", woeid: 123})

      assert_kind_of(Twitter::Place, obj.place)
      assert_equal("NYC", obj.place.name)
    end

    it "returns NullObject when attribute is missing" do
      obj = example_class.new({})

      assert_kind_of(Twitter::NullObject, obj.place)
    end

    it "defines a predicate method" do
      obj = example_class.new(place: {name: "NYC", woeid: 123})

      assert_predicate(obj, :place?)
    end

    describe "with key2 parameter" do
      let(:example_class_with_key2) do
        Class.new(Twitter::Base) do
          object_attr_reader :User, :user, :context_key
        end
      end

      it "passes merged attrs with key2 to the object" do
        # When key2 is provided, attrs_for_object merges other attrs under key2
        obj = example_class_with_key2.new(user: {id: 123, name: "Test"}, extra: "data")
        result = obj.user

        assert_kind_of(Twitter::User, result)
        # The User should have access to :context_key containing remaining attrs
        assert_equal({extra: "data"}, result.attrs[:context_key])
      end

      it "removes key1 from the merged hash" do
        obj = example_class_with_key2.new(user: {id: 123}, other: "value")
        result = obj.user

        refute_operator(result.attrs[:context_key], :key?, :user)
      end

      it "does not mutate the original attrs" do
        original_attrs = {user: {id: 123}, other: "value"}
        obj = example_class_with_key2.new(original_attrs)
        obj.user

        assert_equal({user: {id: 123}, other: "value"}, original_attrs)
      end
    end

    describe "without key2 parameter (default behavior)" do
      let(:example_class_without_key2) do
        Class.new(Twitter::Base) do
          object_attr_reader :Place, :place
        end
      end

      it "returns the attribute value directly from attrs" do
        obj = example_class_without_key2.new(place: {name: "NYC", woeid: 123})
        result = obj.place

        assert_equal("NYC", result.attrs[:name])
        assert_equal(123, result.attrs[:woeid])
      end
    end
  end

  describe ".display_uri_attr_reader" do
    let(:example_class) do
      Class.new(Twitter::Base) do
        display_uri_attr_reader
      end
    end

    it "defines display_url and display_uri methods" do
      obj = example_class.new(display_url: "example.com")

      assert_equal("example.com", obj.display_url)
      assert_equal("example.com", obj.display_uri)
    end

    it "defines predicate methods" do
      obj = example_class.new(display_url: "example.com")

      assert_predicate(obj, :display_url?)
      assert_predicate(obj, :display_uri?)
    end
  end

  describe "private helpers" do
    describe "#attrs_for_object" do
      it "accepts a single key argument and returns nil for unknown keys" do
        base = Twitter::Base.new({})

        assert_nil(base.send(:attrs_for_object, :missing))
      end

      it "returns raw nested attrs when key2 is nil" do
        base = Twitter::Base.new(user: {id: 123}, extra: "data")

        assert_equal({id: 123}, base.send(:attrs_for_object, :user, nil))
      end

      it "returns merged context attrs when key2 is provided" do
        base = Twitter::Base.new(user: {id: 123}, extra: "data")
        merged = base.send(:attrs_for_object, :user, :context)

        assert_equal({extra: "data"}, merged[:context])
        refute_operator(merged[:context], :key?, :user)
      end
    end

    describe "#attr_falsey_or_empty?" do
      it "uses [] access for empty checks (not fetch)" do
        attrs_class = Class.new do
          def [](_key)
            ""
          end

          def fetch(_key)
            raise KeyError, "fetch should not be used"
          end
        end
        base = Twitter::Base.new(attrs_class.new)

        assert(base.send(:attr_falsey_or_empty?, :name))
      end
    end
  end
end
