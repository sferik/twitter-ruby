require "test_helper"

describe Twitter::Streaming::FriendList do
  it "is an array" do
    friend_list = Twitter::Streaming::FriendList.new([1, 2, 3])

    assert_kind_of(Array, friend_list)
    assert_equal(1, friend_list.first)
  end
end
