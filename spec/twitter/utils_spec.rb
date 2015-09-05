require 'benchmark'
require 'helper'

describe Twitter::Utils do
  describe '#pmap' do
    it 'returns an array' do
      expect(subject.flat_pmap([], &:reverse)).to be_an(Array)
    end

    it 'behaves like map' do
      array = (0..9).to_a
      block = proc { |x| x + 1 }
      expect(subject.pmap(array, &block)).to eq(array.collect(&block))
    end

    it 'maps in parallel' do
      delay = 0.1
      array = (0..9).to_a
      size  = array.size
      block = proc { |x| sleep(delay) && x + 1 }
      block_without_sleep = proc { |x| x + 1 }
      expected = array.collect(&block_without_sleep)
      elapsed_time = Benchmark.realtime do
        expect(subject.pmap(array, &block)).to eq(expected)
      end
      expect(elapsed_time).to be_between(delay, delay * size)
    end
  end

  describe '#flat_pmap' do
    it 'always returns an array' do
      expect(subject.flat_pmap([], &:reverse)).to be_an(Array)
    end

    it 'behaves like map for a flat array' do
      array = (0..9).to_a
      block = proc { |x| x + 1 }
      expect(subject.flat_pmap(array, &block)).to eq(array.collect(&block))
    end

    it 'behaves like flat_map' do
      array = (0..4).to_a.combination(2).to_a
      block = proc { |x| x.reverse }
      expect(subject.flat_pmap(array, &block)).to eq(array.flat_map(&block))
    end

    it 'flat maps in parallel' do
      delay = 0.1
      array = (0..4).to_a.combination(2).to_a
      size  = array.size
      block = proc { |x| sleep(delay) && x.reverse }
      block_without_sleep = proc(&:reverse)
      expected = array.collect(&block_without_sleep).flatten!(1)
      elapsed_time = Benchmark.realtime do
        expect(subject.flat_pmap(array, &block)).to eq(expected)
      end
      expect(elapsed_time).to be_between(delay, delay * size)
    end
  end
end
