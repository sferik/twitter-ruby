module MediaObjectExamples
  MEDIA_ID = 110_102_452_988_157_952
  SAMPLE_MEDIA_URI = "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png".freeze
  SIZES = {
    small: {h: 226, w: 340, resize: "fit"},
    large: {h: 466, w: 700, resize: "fit"},
    medium: {h: 399, w: 600, resize: "fit"},
    thumb: {h: 150, w: 150, resize: "crop"}
  }.freeze
  URI_CASES = [
    {name: :expanded_uri, source: :expanded_url},
    {name: :media_uri, source: :media_url},
    {name: :media_uri_https, source: :media_url_https},
    {name: :uri, source: :url}
  ].freeze

  def media_object_examples(klass:)
    media_equality_examples(klass)
    media_sizes_examples(klass)
    display_uri_examples
    URI_CASES.each { |test_case| uri_examples(test_case, klass) }
  end

  private

  def media_equality_examples(klass)
    describe "#==" do
      id_equality_example(klass, "returns true when objects IDs are the same", 1, 1, :assert_equal)
      id_equality_example(klass, "returns false when objects IDs are different", 1, 2, :refute_equal)
      class_equality_example(klass)
    end
  end

  def id_equality_example(klass, description, media_id, other_id, assertion)
    it description do
      media = klass.new(id: media_id)
      other = klass.new(id: other_id)

      send(assertion, media, other)
    end
  end

  def class_equality_example(klass)
    it "returns false when classes are different" do
      media = klass.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(media, other)
    end
  end

  def media_sizes_examples(klass)
    describe "#sizes" do
      sizes_present_example(klass)
      sizes_missing_example(klass)
    end
  end

  def sizes_present_example(klass)
    it "returns a hash of Sizes when sizes is set" do
      sizes = klass.new(id: MEDIA_ID, sizes: SIZES).sizes

      assert_kind_of(Hash, sizes)
      assert_kind_of(Twitter::Size, sizes[:small])
    end
  end

  def sizes_missing_example(klass)
    it "is empty when sizes is not set" do
      sizes = klass.new(id: MEDIA_ID).sizes

      assert_empty(sizes)
    end
  end

  def display_uri_examples
    describe "#display_uri" do
      display_uri_value_example
      display_uri_nil_example
    end
    describe "#display_uri?" do
      display_uri_predicate_true_example
      display_uri_predicate_false_example
    end
  end

  def display_uri_value_example
    it "returns a String when the display_url is set" do
      photo = Twitter::Media::Photo.new(id: 1, display_url: "example.com/expanded...")

      assert_kind_of(String, photo.display_uri)
      assert_equal("example.com/expanded...", photo.display_uri)
    end
  end

  def display_uri_nil_example
    it "returns nil when the display_url is not set" do
      photo = Twitter::Media::Photo.new(id: 1)

      assert_nil(photo.display_uri)
    end
  end

  def display_uri_predicate_true_example
    it "returns true when the display_url is set" do
      photo = Twitter::Media::Photo.new(id: 1, display_url: "example.com/expanded...")

      assert_predicate(photo, :display_uri?)
    end
  end

  def display_uri_predicate_false_example
    it "returns false when the display_url is not set" do
      photo = Twitter::Media::Photo.new(id: 1)

      refute_predicate(photo, :display_uri?)
    end
  end

  def uri_examples(test_case, klass)
    describe "##{test_case[:name]}" do
      uri_value_example(test_case[:name], test_case[:source], klass)
      uri_nil_example(test_case[:name], test_case[:source], klass)
    end
    describe "##{test_case[:name]}?" do
      uri_predicate_true_example(test_case[:name], test_case[:source], klass)
      uri_predicate_false_example(test_case[:name], test_case[:source], klass)
    end
  end

  def uri_value_example(method_name, source_name, klass)
    it "returns a URI when the #{source_name} is set" do
      media = klass.new({id: 1}.merge(source_name => SAMPLE_MEDIA_URI))

      assert_kind_of(Addressable::URI, media.public_send(method_name))
      assert_equal(SAMPLE_MEDIA_URI, media.public_send(method_name).to_s)
    end
  end

  def uri_nil_example(method_name, source_name, klass)
    it "returns nil when the #{source_name} is not set" do
      media = klass.new(id: 1)

      assert_nil(media.public_send(method_name))
    end
  end

  def uri_predicate_true_example(method_name, source_name, klass)
    it "returns true when the #{source_name} is set" do
      media = klass.new({id: 1}.merge(source_name => SAMPLE_MEDIA_URI))

      assert_predicate(media, :"#{method_name}?")
    end
  end

  def uri_predicate_false_example(method_name, source_name, klass)
    it "returns false when the #{source_name} is not set" do
      media = klass.new(id: 1)

      refute_predicate(media, :"#{method_name}?")
    end
  end
end

Minitest::Spec.extend(MediaObjectExamples)
