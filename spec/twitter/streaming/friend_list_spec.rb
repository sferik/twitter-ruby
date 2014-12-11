require 'helper'

describe Twitter::Streaming::FriendList do
  it 'is an array' do
    friend_list = Twitter::Streaming::FriendList.new([1, 2, 3])
    expect(friend_list).to be_an Array
    expect(friend_list.first).to eq(1)
  end
end
