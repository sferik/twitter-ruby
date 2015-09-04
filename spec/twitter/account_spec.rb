# coding: utf-8
require 'helper'

describe Twitter::Account do
  describe '#==' do
    it 'returns true when objects IDs are the same' do
      account = Twitter::Account.new(id: 1, name: 'foo')
      other = Twitter::Account.new(id: 1, name: 'bar')
      expect(account == other).to be true
    end
    it 'returns false when objects IDs are different' do
      account = Twitter::Account.new(id: 1)
      other = Twitter::Account.new(id: 2)
      expect(account == other).to be false
    end
    it 'returns false when classes are different' do
      account = Twitter::Account.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(account == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created at is set' do
      account = Twitter::Account.new(id: 'abjd83j', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(account.created_at).to be_a Time
      expect(account.created_at).to be_utc
    end

    it 'returns nil when created_at is not set' do
      account = Twitter::Account.new(id: 'abjd83j')
      expect(account.created_at).to be_nil
    end
  end

  describe '#created?' do
    it 'returns true when created at is set' do
      account = Twitter::Account.new(id: 'abjd83j', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(account.created?).to be true
    end
    it 'returns false when created at is not set' do
      account = Twitter::Account.new(id: 'abjd83j')
      expect(account.created?).to be false
    end
  end

  describe '#approved?' do
    it 'returns true when approval status is ACCEPTED' do
      account = Twitter::Account.new(id: 'abjd83j', approval_status: 'ACCEPTED')
      expect(account.approved?).to be true
    end
    it 'returns false when approval status is not set' do
      account = Twitter::Account.new(id: 'abjd83j')
      expect(account.approved?).to be false
    end
    it 'returns false when approval status is not ACCEPTED' do
      account = Twitter::Account.new(id: 'abjd83j', approval_status: 'PENDING')
      expect(account.approved?).to be false
    end
  end
end
