require "benchmark"
require "helper"

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
      expect(utils_includer.send(:flat_pmap, [], &:reverse)).to be_an(Array)
    end

    it "behaves like map" do
      array = (0..9).to_a
      block = proc { |x| x + 1 }
      expect(utils_includer.send(:pmap, array, &block)).to eq(array.collect(&block))
    end

    it "maps all elements and returns correct results" do
      array = (0..9).to_a
      block = proc { |x| x + 1 }
      expected = array.collect(&block)
      expect(utils_includer.send(:pmap, array, &block)).to eq(expected)
    end

    it "returns an enumerator when no block is given" do
      array = (0..9).to_a
      enumerator = utils_includer.send(:pmap, array)
      expect(enumerator).to be_an(Enumerator)
      # Verify enumerator yields the same results when iterated with a block
      expect(enumerator.each { |x| x + 1 }).to eq(array.collect { |x| x + 1 })
    end

    it "collects single-element arrays correctly" do
      array = [1]
      block = proc { |x| x + 1 }
      expect(utils_includer.send(:pmap, array, &block)).to eq([2])
    end

    it "processes multi-element arrays correctly" do
      array = [1, 2]
      result = utils_includer.send(:pmap, array) { |x| x * 2 }
      expect(result).to eq([2, 4])
    end

    it "passes the object to the block" do
      array = [10, 20, 30]
      result = utils_includer.send(:pmap, array) { |x| x }
      expect(result).to eq([10, 20, 30])
    end

    it "yields each object exactly once with correct value" do
      array = %i[a b c]
      yielded_values = []
      result = utils_includer.send(:pmap, array) do |x|
        yielded_values << x
        x
      end
      expect(yielded_values.sort).to eq(%i[a b c])
      expect(result.sort).to eq(%i[a b c])
    end

    it "yields the actual object value not nil" do
      # This test specifically detects yield vs yield(object) mutations
      result = utils_includer.send(:pmap, [5, 10, 15]) { |val| val.nil? ? :was_nil : val + 100 }
      expect(result).to eq([105, 110, 115])
    end

    it "does not yield nil when objects are truthy" do
      array = [1, 2, 3]
      result = utils_includer.send(:pmap, array) { |x| x.nil? ? :was_nil : x }
      expect(result).to eq([1, 2, 3])
    end

    it "yields exactly one argument to the block" do
      # This test will fail if yield is called without arguments
      array = [42]
      result = utils_includer.send(:pmap, array) { |x| x || :default }
      expect(result).to eq([42])
    end

    it "yields distinct non-nil values for each element" do
      # Forces use of the actual element values
      array = [Object.new, Object.new]
      result = utils_includer.send(:pmap, array, &:object_id)
      expect(result).to eq(array.collect(&:object_id))
    end

    it "returns early with enumerator when no block given" do
      array = [1, 2, 3]
      # This should return immediately without processing the array
      result = utils_includer.send(:pmap, array)
      expect(result).to be_an(Enumerator)
      expect(result.size).to be_nil
      # Verify the enumerator yields from the original array
      expect(result.to_a).to eq([1, 2, 3])
    end

    it "processes with block instead of returning enumerator" do
      array = [1, 2]
      block_called = false
      result = utils_includer.send(:pmap, array) do |x|
        block_called = true
        x * 2
      end
      expect(block_called).to be true
      expect(result).to eq([2, 4])
    end
  end

  describe "#flat_pmap" do
    it "always returns an array" do
      expect(utils_includer.send(:flat_pmap, [], &:reverse)).to be_an(Array)
    end

    it "behaves like map for a flat array" do
      array = (0..9).to_a
      block = proc { |x| x + 1 }
      expect(utils_includer.send(:flat_pmap, array, &block)).to eq(array.collect(&block))
    end

    it "behaves like flat_map" do
      array = (0..4).to_a.combination(2).to_a
      block = proc(&:reverse)
      expect(utils_includer.send(:flat_pmap, array, &block)).to eq(array.flat_map(&block))
    end

    it "flat maps all elements and returns correct results" do
      array = (0..4).to_a.combination(2).to_a
      block = proc(&:reverse)
      expected = array.flat_map(&block)
      expect(utils_includer.send(:flat_pmap, array, &block)).to eq(expected)
    end

    it "returns an enumerator when no block is given" do
      array = (0..9).to_a
      enumerator = utils_includer.send(:flat_pmap, array)
      expect(enumerator).to be_an(Enumerator)
      # Verify enumerator yields the same results when iterated with a block
      expect(enumerator.each { |x| [x, x] }).to eq(array.flat_map { |x| [x, x] })
    end

    it "flattens only one level" do
      array = [[[1, 2]], [[3, 4]]]
      result = utils_includer.send(:flat_pmap, array, &:itself)
      expect(result).to eq([[1, 2], [3, 4]])
    end
  end
end
