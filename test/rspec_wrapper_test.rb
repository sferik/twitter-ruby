require_relative "test_helper"

SPEC_ROOT = File.expand_path("../spec", __dir__)
SPEC_FILES = Dir[File.join(SPEC_ROOT, "**/*_spec.rb")].sort

DESCRIBE_REGEX = /^\s*describe\s+([A-Z][\w:]+)\b/.freeze

SPEC_FILES.each do |spec_file|
  constants = []

  File.foreach(spec_file) do |line|
    match = line.match(DESCRIBE_REGEX)
    constants << match[1] if match
  end

  constants.uniq!
  next if constants.nil? || constants.empty?

  class_name = "RSpecWrapper_#{spec_file.sub("#{SPEC_ROOT}/", "").gsub(/[^a-zA-Z0-9]+/, "_").gsub(/\A_+|_+\z/, "")}".freeze
  spec_path = spec_file
  covered_constants = constants.dup

  klass = Class.new(Minitest::Test) do
    covered_constants.each { |constant| cover constant }

    define_method(:test_rspec) do
      result = RSpecWrapper.run(spec_path)
      assert_equal 0, result, "RSpec failed for #{spec_path}"
    end
  end

  Object.const_set(class_name, klass)
end
