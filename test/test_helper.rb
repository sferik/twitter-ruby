# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
$LOAD_PATH.unshift(File.expand_path(__dir__))

unless ENV["MUTANT"]
  require "simplecov"

  SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]

  SimpleCov.start do
    enable_coverage :branch
    add_filter "/test/"
    add_filter "/vendor/"
    minimum_coverage line: 100, branch: 100
  end
end

if ENV["MUTANT"]
  require "minitest"
else
  require "minitest/autorun"
end
require "minitest/spec"
require "mutant/minitest/coverage"

require_relative "support/spec_support"
