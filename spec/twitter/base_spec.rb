require "helper"

describe Twitter::Base do
  before do
    @base = described_class.new(id: 1)
  end

  describe "#[]" do
    it "calls methods using [] with symbol" do
      capture_warning do
        expect(@base[:object_id]).to be_an Integer
      end
    end

    it "calls methods using [] with string" do
      capture_warning do
        expect(@base["object_id"]).to be_an Integer
      end
    end

    it "returns nil for missing method" do
      capture_warning do
        expect(@base[:foo]).to be_nil
        expect(@base["foo"]).to be_nil
      end
    end

    it "emits a deprecation warning with caller info and method name" do
      warning = capture_warning { @base[:object_id] }
      expect(warning).to include("[DEPRECATION]")
      expect(warning).to include(":object_id")
      expect(warning).to include("Use #object_id")
      expect(warning).to match(/\.rb:\d+:/) # caller location format with path:lineno:
    end

    it "calls caller_locations with exactly one caller frame" do
      location = instance_double("Thread::Backtrace::Location", path: "spec/file.rb", lineno: 123, to_s: "sentinel")
      expect(@base).to receive(:caller_locations).with(1, 1).and_return([location])

      warning = capture_warning { @base[:object_id] }
      expect(warning).to eq("spec/file.rb:123: [DEPRECATION] #[:object_id] is deprecated. Use #object_id to fetch the value.\n")
    end

    it "supports any method-like object that responds to to_sym" do
      method_name = instance_double("MethodName")
      allow(method_name).to receive(:to_sym).and_return(:object_id)

      capture_warning do
        expect(@base[method_name]).to be_an Integer
      end
    end

    it "does not raise when caller location is nil" do
      allow(@base).to receive(:caller_locations).with(1, 1).and_return([nil])

      warning = capture_warning do
        expect(@base[:object_id]).to be_an Integer
      end
      expect(warning).to include("[DEPRECATION]")
    end

    it "still works when caller_locations itself returns nil" do
      allow(@base).to receive(:caller_locations).with(1, 1).and_return(nil)

      capture_warning do
        expect(@base[:object_id]).to be_an Integer
      end
    end
  end

  describe "#attrs" do
    it "returns a hash of attributes" do
      expect(@base.attrs).to eq(id: 1)
    end
  end

  describe "#initialize" do
    it "converts nil to empty hash" do
      base = described_class.new(nil)
      expect(base.attrs).to eq({})
    end

    it "works with no arguments (defaults to empty hash)" do
      base = described_class.new
      expect(base.attrs).to eq({})
    end

    it "uses the provided hash directly" do
      attrs = {id: 42}
      base = described_class.new(attrs)
      expect(base.attrs).to eq({id: 42})
    end
  end

  describe ".attr_reader" do
    let(:test_class) do
      Class.new(described_class) do
        attr_reader :name, :tags
      end
    end

    it "defines an attribute reader method" do
      obj = test_class.new(name: "test")
      expect(obj.name).to eq("test")
    end

    it "defines a predicate method" do
      obj = test_class.new(name: "test")
      expect(obj.name?).to be true
    end

    it "returns NullObject when attribute is missing" do
      obj = test_class.new({})
      expect(obj.name).to be_a Twitter::NullObject
    end

    it "returns false from predicate when attribute is missing" do
      obj = test_class.new({})
      expect(obj.name?).to be false
    end

    it "treats explicit nil as falsey (key exists but value is nil)" do
      obj = test_class.new(name: nil)
      expect(obj.name?).to be false
      expect(obj.name).to be_a Twitter::NullObject
    end

    it "returns NullObject when attribute is empty array" do
      obj = test_class.new(tags: [])
      expect(obj.tags).to be_a Twitter::NullObject
    end

    it "returns false from predicate when attribute is empty" do
      obj = test_class.new(tags: [])
      expect(obj.tags?).to be false
    end

    it "returns the array when it has items" do
      obj = test_class.new(tags: ["ruby"])
      expect(obj.tags).to eq(["ruby"])
      expect(obj.tags?).to be true
    end

    it "memoizes the attribute value" do
      obj = test_class.new(name: "test")
      first_call = obj.name
      second_call = obj.name
      expect(first_call).to equal(second_call)
    end

    it "memoizes the predicate value" do
      obj = test_class.new(name: "test")
      first_call = obj.name?
      second_call = obj.name?
      expect(first_call).to eq(second_call)
    end

    it "memoizes values even when [] returns a fresh object each time" do
      volatile_attrs_class = Class.new do
        def [](_key)
          Object.new
        end
      end
      obj = test_class.new(volatile_attrs_class.new)

      expect(obj.name).to equal(obj.name)
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
      obj = test_class.new(attrs_class.new)

      expect(obj.name).to eq("value-from-brackets")
    end

    it "memoizes predicate values even when backing attrs change" do
      attrs = {name: "present"}
      obj = test_class.new(attrs)
      expect(obj.name?).to be(true)

      attrs[:name] = nil
      expect(obj.name?).to be(true)
    end
  end

  describe ".predicate_attr_reader" do
    let(:test_class) do
      Class.new(described_class) do
        predicate_attr_reader :active
      end
    end

    it "defines a predicate method" do
      obj = test_class.new(active: true)
      expect(obj.active?).to be true
    end

    it "returns false when attribute is missing" do
      obj = test_class.new({})
      expect(obj.active?).to be false
    end
  end

  describe ".uri_attr_reader" do
    let(:test_class) do
      Class.new(described_class) do
        uri_attr_reader :profile_uri
      end
    end

    it "defines a URI method that parses the URL attribute" do
      obj = test_class.new(profile_url: "https://example.com/profile")
      expect(obj.profile_uri).to be_a Addressable::URI
      expect(obj.profile_uri.to_s).to eq("https://example.com/profile")
    end

    it "aliases the url method" do
      obj = test_class.new(profile_url: "https://example.com/profile")
      expect(obj.profile_url).to eq(obj.profile_uri)
    end

    it "returns nil when URL attribute is missing" do
      obj = test_class.new({})
      expect(obj.profile_uri).to be_nil
    end

    it "defines predicate methods for both uri and url" do
      obj = test_class.new(profile_url: "https://example.com")
      expect(obj.profile_uri?).to be true
      expect(obj.profile_url?).to be true
    end

    it "strips trailing # from URLs" do
      obj = test_class.new(profile_url: "https://example.com#")
      expect(obj.profile_uri.to_s).to eq("https://example.com")
    end

    it "memoizes the URI value" do
      obj = test_class.new(profile_url: "https://example.com")
      first_call = obj.profile_uri
      second_call = obj.profile_uri
      expect(first_call).to equal(second_call)
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
      obj = test_class.new(attrs_class.new)

      expect(obj.profile_uri.to_s).to eq("https://example.com/profile")
    end
  end

  describe ".object_attr_reader" do
    let(:test_class) do
      Class.new(described_class) do
        object_attr_reader :Place, :place
      end
    end

    it "defines a method that returns an object of the specified class" do
      obj = test_class.new(place: {name: "NYC", woeid: 123})
      expect(obj.place).to be_a Twitter::Place
      expect(obj.place.name).to eq("NYC")
    end

    it "returns NullObject when attribute is missing" do
      obj = test_class.new({})
      expect(obj.place).to be_a Twitter::NullObject
    end

    it "defines a predicate method" do
      obj = test_class.new(place: {name: "NYC", woeid: 123})
      expect(obj.place?).to be true
    end

    context "with key2 parameter" do
      let(:test_class_with_key2) do
        Class.new(described_class) do
          object_attr_reader :User, :user, :context_key
        end
      end

      it "passes merged attrs with key2 to the object" do
        # When key2 is provided, attrs_for_object merges other attrs under key2
        obj = test_class_with_key2.new(user: {id: 123, name: "Test"}, extra: "data")
        result = obj.user
        expect(result).to be_a Twitter::User
        # The User should have access to :context_key containing remaining attrs
        expect(result.attrs[:context_key]).to include(extra: "data")
      end

      it "removes key1 from the merged hash" do
        obj = test_class_with_key2.new(user: {id: 123}, other: "value")
        result = obj.user
        expect(result.attrs[:context_key]).not_to have_key(:user)
      end

      it "does not mutate the original attrs" do
        original_attrs = {user: {id: 123}, other: "value"}
        obj = test_class_with_key2.new(original_attrs)
        obj.user
        expect(original_attrs).to eq({user: {id: 123}, other: "value"})
      end
    end

    context "without key2 parameter (default behavior)" do
      let(:test_class_without_key2) do
        Class.new(described_class) do
          object_attr_reader :Place, :place
        end
      end

      it "returns the attribute value directly from attrs" do
        obj = test_class_without_key2.new(place: {name: "NYC", woeid: 123})
        result = obj.place
        expect(result.attrs[:name]).to eq("NYC")
        expect(result.attrs[:woeid]).to eq(123)
      end
    end
  end

  describe ".display_uri_attr_reader" do
    let(:test_class) do
      Class.new(described_class) do
        display_uri_attr_reader
      end
    end

    it "defines display_url and display_uri methods" do
      obj = test_class.new(display_url: "example.com")
      expect(obj.display_url).to eq("example.com")
      expect(obj.display_uri).to eq("example.com")
    end

    it "defines predicate methods" do
      obj = test_class.new(display_url: "example.com")
      expect(obj.display_url?).to be true
      expect(obj.display_uri?).to be true
    end
  end

  describe "private helpers" do
    describe "#attrs_for_object" do
      it "accepts a single key argument and returns nil for unknown keys" do
        base = described_class.new({})

        expect(base.send(:attrs_for_object, :missing)).to be_nil
      end

      it "returns raw nested attrs when key2 is nil" do
        base = described_class.new(user: {id: 123}, extra: "data")

        expect(base.send(:attrs_for_object, :user, nil)).to eq(id: 123)
      end

      it "returns merged context attrs when key2 is provided" do
        base = described_class.new(user: {id: 123}, extra: "data")
        merged = base.send(:attrs_for_object, :user, :context)

        expect(merged[:context]).to include(extra: "data")
        expect(merged[:context]).not_to have_key(:user)
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
        base = described_class.new(attrs_class.new)

        expect(base.send(:attr_falsey_or_empty?, :name)).to be(true)
      end
    end
  end
end
