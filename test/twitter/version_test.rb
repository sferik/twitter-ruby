require "test_helper"

describe Twitter::Version do
  describe ".major" do
    it "returns the correct major version" do
      assert_equal(8, Twitter::Version.major)
    end
  end

  describe ".minor" do
    it "returns the correct minor version" do
      assert_equal(2, Twitter::Version.minor)
    end
  end

  describe ".patch" do
    it "returns the correct patch version" do
      assert_equal(0, Twitter::Version.patch)
    end
  end

  describe ".pre" do
    it "returns nil for stable releases" do
      assert_nil(Twitter::Version.pre)
    end
  end

  describe ".to_h" do
    it "returns a hash with version components" do
      result = Twitter::Version.to_h

      assert_equal(8, result[:major])
      assert_equal(2, result[:minor])
      assert_equal(0, result[:patch])
      assert_operator(result, :key?, :pre)
    end
  end

  describe ".to_a" do
    it "returns an array with major, minor, patch" do
      assert_equal([8, 2, 0], Twitter::Version.to_a)
    end
  end

  describe ".to_s" do
    it "returns version string joined with dots" do
      assert_equal("8.2.0", Twitter::Version.to_s)
    end
  end
end
