require "benchmark"
require "test_helper"

describe Twitter::Utils do
  # Create a test class that includes the Utils module to test instance methods
  # The methods are private when included via module_function, so we use send
  let(:utils_includer) do
    Class.new do
      include Twitter::Utils
    end.new
  end

  describe "#pmap" do
    it "returns an array" do
      assert_kind_of(Array, utils_includer.send(:flat_pmap, [], &:reverse))
    end

    it "behaves like map" do
      array = (0..9).to_a
      block = proc { |x| x + 1 }

      assert_equal(array.collect(&block), utils_includer.send(:pmap, array, &block))
    end

    it "maps all elements and returns correct results" do
      array = (0..9).to_a
      block = proc { |x| x + 1 }
      expected = array.collect(&block)

      assert_equal(expected, utils_includer.send(:pmap, array, &block))
    end

    it "returns an enumerator when no block is given" do
      array = (0..9).to_a
      enumerator = utils_includer.send(:pmap, array)

      assert_kind_of(Enumerator, enumerator)
      # Verify enumerator yields the same results when iterated with a block
      assert_equal(array.collect { |x| x + 1 }, enumerator.each { |x| x + 1 })
    end

    it "collects single-element arrays correctly" do
      array = [1]
      block = proc { |x| x + 1 }

      assert_equal([2], utils_includer.send(:pmap, array, &block))
    end

    it "processes multi-element arrays correctly" do
      array = [1, 2]
      result = utils_includer.send(:pmap, array) { |x| x * 2 }

      assert_equal([2, 4], result)
    end

    it "passes the object to the block" do
      array = [10, 20, 30]
      result = utils_includer.send(:pmap, array) { |x| x }

      assert_equal([10, 20, 30], result)
    end

    it "yields each object exactly once with correct value" do
      array = %i[a b c]
      yielded_values = []
      result = utils_includer.send(:pmap, array) do |x|
        yielded_values << x
        x
      end

      assert_equal(%i[a b c], yielded_values.sort)
      assert_equal(%i[a b c], result.sort)
    end

    it "yields the actual object value not nil" do
      # This test specifically detects yield vs yield(object) mutations
      result = utils_includer.send(:pmap, [5, 10, 15]) { |val| val.nil? ? :was_nil : val + 100 }

      assert_equal([105, 110, 115], result)
    end

    it "does not yield nil when objects are truthy" do
      array = [1, 2, 3]
      result = utils_includer.send(:pmap, array) { |x| x.nil? ? :was_nil : x }

      assert_equal([1, 2, 3], result)
    end

    it "yields exactly one argument to the block" do
      # This test will fail if yield is called without arguments
      array = [42]
      result = utils_includer.send(:pmap, array) { |x| x || :default }

      assert_equal([42], result)
    end

    it "yields distinct non-nil values for each element" do
      # Forces use of the actual element values
      array = [Object.new, Object.new]
      result = utils_includer.send(:pmap, array, &:object_id)

      assert_equal(array.collect(&:object_id), result)
    end

    it "returns early with enumerator when no block given" do
      array = [1, 2, 3]
      # This should return immediately without processing the array
      result = utils_includer.send(:pmap, array)

      assert_kind_of(Enumerator, result)
      assert_nil(result.size)
      # Verify the enumerator yields from the original array
      assert_equal([1, 2, 3], result.to_a)
    end

    it "processes with block instead of returning enumerator" do
      array = [1, 2]
      block_called = false
      result = utils_includer.send(:pmap, array) do |x|
        block_called = true
        x * 2
      end

      assert(block_called)
      assert_equal([2, 4], result)
    end
  end

  describe "#flat_pmap" do
    it "always returns an array" do
      assert_kind_of(Array, utils_includer.send(:flat_pmap, [], &:reverse))
    end

    it "behaves like map for a flat array" do
      array = (0..9).to_a
      block = proc { |x| x + 1 }

      assert_equal(array.collect(&block), utils_includer.send(:flat_pmap, array, &block))
    end

    it "behaves like flat_map" do
      array = (0..4).to_a.combination(2).to_a
      block = proc(&:reverse)

      assert_equal(array.flat_map(&block), utils_includer.send(:flat_pmap, array, &block))
    end

    it "flat maps all elements and returns correct results" do
      array = (0..4).to_a.combination(2).to_a
      block = proc(&:reverse)
      expected = array.flat_map(&block)

      assert_equal(expected, utils_includer.send(:flat_pmap, array, &block))
    end

    it "returns an enumerator when no block is given" do
      array = (0..9).to_a
      enumerator = utils_includer.send(:flat_pmap, array)

      assert_kind_of(Enumerator, enumerator)
      # Verify enumerator yields the same results when iterated with a block
      assert_equal(array.flat_map { |x| [x, x] }, enumerator.each { |x| [x, x] })
    end

    it "flattens only one level" do
      array = [[[1, 2]], [[3, 4]]]
      result = utils_includer.send(:flat_pmap, array, &:itself)

      assert_equal([[1, 2], [3, 4]], result)
    end
  end
end
