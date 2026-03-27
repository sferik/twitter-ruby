require "test_helper"

describe Twitter::Version do
  def gemspec_version
    Gem.loaded_specs.fetch("twitter").version
  end

  describe ".major" do
    it "returns the correct major version" do
      assert_pattern { Twitter::Version.major => ^(gemspec_version.segments[0]) }
    end
  end

  describe ".minor" do
    it "returns the correct minor version" do
      assert_pattern { Twitter::Version.minor => ^(gemspec_version.segments[1]) }
    end
  end

  describe ".patch" do
    it "returns the correct patch version" do
      assert_pattern { Twitter::Version.patch => ^(gemspec_version.segments[2]) }
    end
  end

  describe ".pre" do
    it "returns nil for stable releases" do
      assert_pattern { Twitter::Version.pre => nil }
    end
  end

  describe ".to_h" do
    it "returns a hash with version components" do
      major, minor, patch = gemspec_version.segments
      assert_pattern { Twitter::Version.to_h => {major: ^major, minor: ^minor, patch: ^patch, pre: nil, **nil} }
    end
  end

  describe ".to_a" do
    it "returns an array with major, minor, patch" do
      major, minor, patch = gemspec_version.segments
      assert_pattern { Twitter::Version.to_a => [^major, ^minor, ^patch] }
    end
  end

  describe ".to_s" do
    it "returns version string joined with dots" do
      assert_pattern { Twitter::Version.to_s => ^(gemspec_version.to_s) }
    end
  end
end
