require 'helper'

describe Twitter::Streaming::Info do
  describe 'initialization' do
    it 'handles the nested info attributes' do
      info = Twitter::Streaming::Info.new(info: {with: 'user'})
      expect(info.with).to eq('user')
    end
  end

  describe '#users' do
    it 'returns an Array of Twitter::Streaming::User objects' do
      info = Twitter::Streaming::Info.new(info: {users: [{id: 123_456, name: 'sferik', dm: false}]})
      expect(info.users).to be_an Array
      expect(info.users.first).to be_a Twitter::Streaming::User
    end
  end

  describe '#follows' do
    it 'returns an Array of Twitter::Streaming::User objects' do
      info = Twitter::Streaming::Info.new(info: {follows: [{user: 123_456, other_users: [1, 2]}]})
      expect(info.follows).to be_an Array
      expect(info.follows.first).to be_a Twitter::Streaming::Follow
    end
  end
end
