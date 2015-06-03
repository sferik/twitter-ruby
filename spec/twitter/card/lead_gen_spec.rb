require 'helper'

describe Twitter::Card::LeadGen do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      card = Twitter::Card::LeadGen.new(id: 'ab312', name: 'foo')
      other = Twitter::Card::LeadGen.new(id: 'ab312', name: 'bar')
      expect(card == other).to be true
    end
    it 'returns false when IDs are different' do
      card = Twitter::Card::LeadGen.new(id: 'ab312', name: 'foo')
      other = Twitter::Card::LeadGen.new(id: 'bxfdf', name: 'foo')
      expect(card == other).to be false
    end
    it 'returns false when classes are different' do
      card = Twitter::Card::LeadGen.new(id: 'ab312', name: 'foo')
      other = Twitter::Identity.new(id: 'ab312')
      expect(card == other).to be false
    end
  end

  context '#created_at' do
    it 'returns a Time when created at is set' do
      card = Twitter::Card::LeadGen.new(id: 'abc123', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(card.created_at).to be_a Time
      expect(card.created_at).to be_utc
    end
    it 'returns nil when it is not set' do
      card = Twitter::Card::LeadGen.new(id: 'abc123')
      expect(card.created_at).to be_nil
    end
  end

  context '#custom_params' do
    it 'extracts custom params' do
      card = Twitter::Card::LeadGen.new(id: 'abc123', custom_param_foo: 'bar', custom_param_dog: 'woof')
      expect(card.custom_params).to match({
        foo: 'bar',
        dog: 'woof',
      })
    end
  end
end
