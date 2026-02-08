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
require "minitest/mock"
require "minitest-bonus-assertions"
require "mutant/minitest/coverage"

require "twitter"
require "stringio"
require "tempfile"
require "timecop"
require "webmock/minitest"

require_relative "support/media_object_examples"
require_relative "support/rest_users_profile_image_examples"

module MinitestAutocoverCompatibility
  module_function

  CLASS_NAME_PATTERN = /\A[A-Z][A-Za-z0-9_]*(?:::[A-Z][A-Za-z0-9_]*)*\z/

  def autocover(spec_class, *descriptions)
    return unless spec_class.respond_to?(:cover)

    cover_targets(descriptions).each { |cover_target| spec_class.cover(cover_target) }
  end

  def cover_targets(descriptions)
    descriptions.compact.uniq.filter_map { |description| cover_target_for(description) }
  end

  def cover_target_for(description)
    return description.name if description.is_a?(Module)
    return description if description.is_a?(String) && description.match?(CLASS_NAME_PATTERN)

    nil
  end
end

module MinitestWebMockCompatibility
  def assert_requested(request_or_method, uri = nil, options = nil, **keyword_options, &)
    return super unless request_or_method.is_a?(WebMock::RequestPattern)

    verifier = build_request_execution_verifier(request_or_method, uri, options, keyword_options, default_once: true, &)
    WebMock::AssertionFailure.failure(verifier.failure_message) unless verifier.matches?
  end

  def assert_not_requested(request_or_method, uri = nil, options = nil, **keyword_options, &)
    return super unless request_or_method.is_a?(WebMock::RequestPattern)

    verifier = build_request_execution_verifier(request_or_method, uri, options, keyword_options, default_once: false, &)
    WebMock::AssertionFailure.failure(verifier.failure_message_when_negated) unless verifier.does_not_match?
  end

  private

  def build_request_execution_verifier(request_pattern, uri, options, keyword_options, default_once:, &block)
    raise ArgumentError, "assert_requested with a request pattern doesn't accept blocks" if block

    verification_options = normalize_request_pattern_assertion_options(uri, options, keyword_options)
    times, at_least_times, at_most_times = extract_request_count_options(verification_options)

    times = 1 if default_once && times.nil? && at_least_times.nil? && at_most_times.nil?

    WebMock::RequestExecutionVerifier.new(request_pattern, times, at_least_times, at_most_times)
  end

  def normalize_request_pattern_assertion_options(uri, options, keyword_options)
    extracted_options = [options, uri].find { |value| value.is_a?(Hash) } || {}
    extracted_options.merge(keyword_options).dup
  end

  def extract_request_count_options(verification_options)
    [
      verification_options.delete(:times),
      verification_options.delete(:at_least_times),
      verification_options.delete(:at_most_times)
    ]
  end
end

module TestSupport
  module Assertions
    def assert_nothing_raised
      yield
    rescue => e
      flunk("Expected no exception, but raised #{e.class}: #{e.message}")
    end
  end

  module RequestHelpers
    REQUEST_BASE_URL = Twitter::REST::Request::BASE_URL
    JSON_HEADERS = {content_type: "application/json; charset=utf-8"}.freeze

    def a_delete(path)
      a_request(:delete, REQUEST_BASE_URL + path)
    end

    def a_get(path)
      a_request(:get, REQUEST_BASE_URL + path)
    end

    def a_post(path)
      a_request(:post, REQUEST_BASE_URL + path)
    end

    def a_put(path)
      a_request(:put, REQUEST_BASE_URL + path)
    end

    def stub_delete(path)
      stub_request(:delete, REQUEST_BASE_URL + path)
    end

    def stub_get(path)
      stub_request(:get, REQUEST_BASE_URL + path)
    end

    def stub_post(path)
      stub_request(:post, REQUEST_BASE_URL + path)
    end

    def stub_put(path)
      stub_request(:put, REQUEST_BASE_URL + path)
    end

    def json_headers
      JSON_HEADERS
    end

    def json_response(body:, status: 200, headers: {})
      {body:, status:, headers: JSON_HEADERS.merge(headers)}
    end

    def stub_json_delete(path, body:, status: 200, headers: {})
      stub_delete(path).to_return(json_response(body:, status:, headers:))
    end

    def stub_json_get(path, body:, status: 200, headers: {})
      stub_get(path).to_return(json_response(body:, status:, headers:))
    end

    def stub_json_post(path, body:, status: 200, headers: {})
      stub_post(path).to_return(json_response(body:, status:, headers:))
    end

    def stub_json_put(path, body:, status: 200, headers: {})
      stub_put(path).to_return(json_response(body:, status:, headers:))
    end
  end

  module FixtureHelpers
    FIXTURE_PATH = File.expand_path("fixtures", __dir__).freeze

    def fixture_path
      FIXTURE_PATH
    end

    def fixture(file)
      File.binread(fixture_file_path(file))
    end

    def fixture_file(file)
      File.new(fixture_file_path(file))
    end

    def fixture_file_path(file)
      File.join(fixture_path, file)
    end

    def capture_warning
      original_stderr = $stderr
      $stderr = StringIO.new
      yield
      $stderr.string
    ensure
      $stderr = original_stderr
    end
  end

  module ConstantHelpers
    StubbedConstant = Struct.new(:had_original, :original, keyword_init: true)

    def with_stubbed_const(const_path, replacement)
      parent, const_name = resolve_stubbed_const_path(const_path)
      original = replace_stubbed_const(parent, const_name, replacement)
      yield
    ensure
      restore_stubbed_const(parent, const_name, original)
    end

    private

    def resolve_stubbed_const_path(const_path)
      names = const_path.delete_prefix("::").split("::")
      const_name = names.pop.to_sym
      parent = names.reduce(Object) { |namespace, name| namespace.const_get(name, false) }
      [parent, const_name]
    end

    def replace_stubbed_const(parent, const_name, replacement)
      had_original = parent.const_defined?(const_name, false)
      original = had_original ? parent.const_get(const_name, false) : nil
      parent.send(:remove_const, const_name) if had_original
      parent.const_set(const_name, replacement)
      StubbedConstant.new(had_original:, original:)
    end

    def restore_stubbed_const(parent, const_name, original)
      return if parent.nil? || const_name.nil?

      parent.send(:remove_const, const_name) if parent.const_defined?(const_name, false)
      parent.const_set(const_name, original.original) if original&.had_original
    end
  end

  module ClientHelpers
    REST_CLIENT_CREDENTIALS = {
      consumer_key: "CK",
      consumer_secret: "CS",
      access_token: "AT",
      access_token_secret: "AS"
    }.freeze

    def build_rest_client(**)
      Twitter::REST::Client.new(**REST_CLIENT_CREDENTIALS, **)
    end

    def build_streaming_client(**)
      Twitter::Streaming::Client.new(**REST_CLIENT_CREDENTIALS, **)
    end
  end
end

Minitest::Test.prepend(MinitestWebMockCompatibility)

module Minitest
  class Test
    include TestSupport::Assertions
    include TestSupport::RequestHelpers
    include TestSupport::FixtureHelpers
    include TestSupport::ConstantHelpers
    include TestSupport::ClientHelpers
  end
end

Kernel.module_eval do
  alias_method :original_describe, :describe unless private_method_defined?(:original_describe)

  def describe(desc, *additional_desc, &)
    spec_class = original_describe(desc, *additional_desc, &)
    MinitestAutocoverCompatibility.autocover(spec_class, desc, *additional_desc)
    spec_class
  end
  private :describe
end
