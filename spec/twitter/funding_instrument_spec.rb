require 'helper'

describe Twitter::FundingInstrument do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'ab312')
      other = Twitter::FundingInstrument.new(id: 'ab312')
      expect(funding_instrument == other).to be true
    end
    it 'returns false when IDs are different' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'ab312')
      other = Twitter::FundingInstrument.new(id: 'bxfdf')
      expect(funding_instrument == other).to be false
    end
    it 'returns false when classes are different' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'ab312')
      other = Twitter::Identity.new(id: 'ab312')
      expect(funding_instrument == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created at is set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(funding_instrument.created_at).to be_a Time
      expect(funding_instrument.created_at).to be_utc
    end
    it 'returns nil when it is not set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123')
      expect(funding_instrument.created_at).to be_nil
    end
  end

  describe '#start_time' do
    it 'returns a Time when start time is set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123', start_time: 'Mon July 16 12:59:01 +0000 2007')
      expect(funding_instrument.start_time).to be_a Time
      expect(funding_instrument.start_time).to be_utc
    end
    it 'returns nil when it is not set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123')
      expect(funding_instrument.start_time).to be_nil
    end
  end

  describe '#end_time' do
    it 'returns a Time when end time is set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123', end_time: 'Mon July 16 12:59:01 +0000 2007')
      expect(funding_instrument.end_time).to be_a Time
      expect(funding_instrument.end_time).to be_utc
    end
    it 'returns nil when it is not set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123')
      expect(funding_instrument.end_time).to be_nil
    end
  end

  describe '#credit_limit_local_micro' do
    it 'returns an Integer if set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123', credit_limit_local_micro: 75_000_000)
      expect(funding_instrument.credit_limit_local_micro).to eq(75_000_000)
    end
    it 'returns nil when it is not set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123')
      expect(funding_instrument.credit_limit_local_micro).to be_nil
    end
  end

  describe '#funded_amount_local_micro' do
    it 'returns an Integer if set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123', funded_amount_local_micro: 75_000_000)
      expect(funding_instrument.funded_amount_local_micro).to eq(75_000_000)
    end
    it 'returns nil when it is not set' do
      funding_instrument = Twitter::FundingInstrument.new(id: 'abc123')
      expect(funding_instrument.funded_amount_local_micro).to be_nil
    end
  end
end
