shared_examples_for 'an enumerable' do |opts|
  describe '#each' do
    it_behaves_like 'an enumerable method', :each, opts
  end

  describe '#each_page' do
    it_behaves_like 'an enumerable method', :each_page, opts
    it 'yields an enumerable' do
      enumerable.each_page { |page| expect(page).to be_an(Enumerable) }
    end
  end
end

def enumerator_from_block_args(args)
  args.flatten!(1)
  if args[0].respond_to? :each
    enumerator, _ = args
  else
    enumerator = args
  end
  enumerator
end

shared_examples_for 'an enumerable method' do |method, opts|
  before do
    opts         ||= {}
    opts[:count] ||= 6
    opts[:start] ||= 5
  end
  it 'iterates' do
    count = 0
    enumerable.send(method) do |*args|
      enumerator_from_block_args(args).each { count += 1 }
    end
    expect(count).to eq(opts[:count])
  end
  context 'with start' do
    before do
      @count_after_start = opts[:count] - opts[:start]
    end
    it 'iterates' do
      count = 0
      enumerable.send(method, opts[:start]) do |*args|
        enumerator_from_block_args(args).each { count += 1 }
      end
      expect(count).to eq(@count_after_start)
    end
  end
  context 'when no block is given' do
    it 'returns an enumerable object' do
      expect(enumerable.send(method)).to be_an(Enumerable)
    end
  end
end
