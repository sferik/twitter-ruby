# frozen_string_literal: true

require "cgi"
require "minitest/mock"

module RSpecCompatibility
  SHARED_EXAMPLES = {}
  UNSET = Object.new.freeze

  module_function

  def shared_examples
    SHARED_EXAMPLES
  end

  def matcher_error(message)
    raise ArgumentError, message
  end

  def value_matches?(expected, actual)
    (expected === actual) || (expected == actual)
  end

  def apply_matcher(test, actual, matcher, negate:)
    unless matcher.respond_to?(:assert_match) && matcher.respond_to?(:refute_match)
      matcher_error("Unsupported matcher: #{matcher.inspect}")
    end

    negate ? matcher.refute_match(test, actual) : matcher.assert_match(test, actual)
    true
  end

  def autocover(spec_class, *descriptions)
    return unless spec_class.respond_to?(:cover)

    descriptions
      .compact
      .uniq
      .each do |description|
        cover_target = case description
                       when Module
                         description.name
                       when String
                         description if description.match?(/\A[A-Z][A-Za-z0-9_]*(?:::[A-Z][A-Za-z0-9_]*)*\z/)
                       end

        next if cover_target.nil? || cover_target.empty?

        spec_class.cover(cover_target)
      end
  end

  class AnythingArgMatcher
    def ===(_other)
      true
    end
  end

  class KindOfArgMatcher
    def initialize(klass)
      @klass = klass
    end

    def ===(other)
      other.is_a?(@klass)
    end
  end

  class InstanceOfArgMatcher
    def initialize(klass)
      @klass = klass
    end

    def ===(other)
      other.instance_of?(@klass)
    end
  end

  class HashIncludingArgMatcher
    def initialize(expected)
      @expected = expected
    end

    def ===(other)
      normalized = normalize_hash(other)
      return false unless normalized.is_a?(Hash)

      @expected.all? do |key, value|
        matched_key = if normalized.key?(key)
                        key
                      elsif key.is_a?(String) && normalized.key?(key.to_sym)
                        key.to_sym
                      elsif key.is_a?(Symbol) && normalized.key?(key.to_s)
                        key.to_s
                      end

        next false if matched_key.nil?

        RSpecCompatibility.value_matches?(value, normalized[matched_key])
      end
    end

    alias == ===

    private

    def normalize_hash(other)
      return other if other.is_a?(Hash)
      return CGI.parse(other).transform_values { |values| values.length == 1 ? values.first : values } if other.is_a?(String)

      other.to_hash if other.respond_to?(:to_hash)
    end
  end

  class EqMatcher
    def initialize(expected)
      @expected = expected
    end

    def assert_match(test, actual)
      test.assert_operator(actual, :==, @expected, "Expected #{actual.inspect} to eq #{@expected.inspect}")
    end

    def refute_match(test, actual)
      test.refute_operator(actual, :==, @expected, "Expected #{actual.inspect} not to eq #{@expected.inspect}")
    end
  end

  class EqlMatcher
    def initialize(expected)
      @expected = expected
    end

    def assert_match(test, actual)
      test.assert(actual.eql?(@expected), "Expected #{actual.inspect} to eql #{@expected.inspect}")
    end

    def refute_match(test, actual)
      test.refute(actual.eql?(@expected), "Expected #{actual.inspect} not to eql #{@expected.inspect}")
    end
  end

  class EqualMatcher
    def initialize(expected)
      @expected = expected
    end

    def assert_match(test, actual)
      test.assert_same(@expected, actual)
    end

    def refute_match(test, actual)
      test.refute_same(@expected, actual)
    end
  end

  class BeMatcher
    def initialize(expected = UNSET)
      @expected = expected
    end

    def assert_match(test, actual)
      if @expected.equal?(UNSET)
        test.assert(actual)
      elsif @expected == true || @expected == false || @expected.nil?
        test.assert_equal(@expected, actual)
      else
        test.assert_same(@expected, actual)
      end
    end

    def refute_match(test, actual)
      if @expected.equal?(UNSET)
        test.refute(actual)
      elsif @expected == true || @expected == false || @expected.nil?
        test.refute_equal(@expected, actual)
      else
        test.refute_same(@expected, actual)
      end
    end

    def <(other)
      OperatorMatcher.new(:<, other)
    end

    def <=(other)
      OperatorMatcher.new(:<=, other)
    end

    def >(other)
      OperatorMatcher.new(:>, other)
    end

    def >=(other)
      OperatorMatcher.new(:>=, other)
    end
  end

  class OperatorMatcher
    def initialize(operator, expected)
      @operator = operator
      @expected = expected
    end

    def assert_match(test, actual)
      test.assert_operator(actual, @operator, @expected)
    end

    def refute_match(test, actual)
      test.refute(actual.public_send(@operator, @expected))
    end
  end

  class BeKindOfMatcher
    def initialize(klass)
      @klass = klass
    end

    def assert_match(test, actual)
      test.assert_kind_of(@klass, actual)
    end

    def refute_match(test, actual)
      test.refute_kind_of(@klass, actual, "Expected #{actual.inspect} not to be a #{@klass}")
    end
  end

  class BeInstanceOfMatcher
    def initialize(klass)
      @klass = klass
    end

    def assert_match(test, actual)
      test.assert_instance_of(@klass, actual)
    end

    def refute_match(test, actual)
      test.refute(actual.instance_of?(@klass), "Expected #{actual.inspect} not to be instance of #{@klass}")
    end
  end

  class BeNilMatcher
    def assert_match(test, actual)
      test.assert_nil(actual)
    end

    def refute_match(test, actual)
      test.refute_nil(actual)
    end
  end

  class BeEmptyMatcher
    def assert_match(test, actual)
      test.assert_respond_to(actual, :empty?)
      test.assert_empty(actual, "Expected #{actual.inspect} to be empty")
    end

    def refute_match(test, actual)
      test.assert_respond_to(actual, :empty?)
      test.refute_empty(actual, "Expected #{actual.inspect} not to be empty")
    end
  end

  class HaveKeyMatcher
    def initialize(key)
      @key = key
    end

    def assert_match(test, actual)
      test.assert_respond_to(actual, :key?)
      test.assert(actual.key?(@key), "Expected #{actual.inspect} to have key #{@key.inspect}")
    end

    def refute_match(test, actual)
      test.assert_respond_to(actual, :key?)
      test.refute(actual.key?(@key), "Expected #{actual.inspect} not to have key #{@key.inspect}")
    end
  end

  class IncludeMatcher
    def initialize(expected)
      @expected = expected
    end

    def assert_match(test, actual)
      @expected.each do |item|
        if actual.is_a?(Hash) && item.is_a?(Hash)
          item.each do |key, value|
            test.assert(actual.key?(key), "Expected #{actual.inspect} to include key #{key.inspect}")
            next unless actual.key?(key)
            test.assert(
              RSpecCompatibility.value_matches?(value, actual[key]),
              "Expected #{actual.inspect} to include #{item.inspect}",
            )
          end
        else
          test.assert_includes(actual, item)
        end
      end
    end

    def refute_match(test, actual)
      @expected.each do |item|
        if actual.is_a?(Hash) && item.is_a?(Hash)
          includes_all_pairs = item.all? do |key, value|
            actual.key?(key) && RSpecCompatibility.value_matches?(value, actual[key])
          end
          test.refute(includes_all_pairs, "Expected #{actual.inspect} not to include #{item.inspect}")
        else
          test.refute_includes(actual, item)
        end
      end
    end
  end

  class MatchMatcher
    def initialize(pattern)
      @pattern = pattern
    end

    def assert_match(test, actual)
      test.assert_match(@pattern, actual)
    end

    def refute_match(test, actual)
      test.refute_match(@pattern, actual)
    end
  end

  class RespondToMatcher
    def initialize(method_name)
      @method_name = method_name
    end

    def assert_match(test, actual)
      test.assert_respond_to(actual, @method_name)
    end

    def refute_match(test, actual)
      test.refute_respond_to(actual, @method_name, "Expected #{actual.inspect} not to respond to #{@method_name}")
    end
  end

  class AllMatcher
    def initialize(matcher)
      @matcher = matcher
    end

    def assert_match(test, actual)
      actual.each do |item|
        RSpecCompatibility.apply_matcher(test, item, @matcher, negate: false)
      end
    end

    def refute_match(test, actual)
      any_non_match = actual.any? do |item|
        begin
          RSpecCompatibility.apply_matcher(test, item, @matcher, negate: false)
          false
        rescue Minitest::Assertion
          true
        end
      end

      test.assert(any_non_match, "Expected at least one value not to match #{actual.inspect}")
    end
  end

  class RaiseErrorMatcher
    def initialize(error_class = Exception)
      @error_class = error_class
    end

    def assert_match(test, actual)
      test.assert_respond_to(actual, :call)
      test.assert_raises(@error_class) { actual.call }
    end

    def refute_match(test, actual)
      test.assert_respond_to(actual, :call)
      actual.call
    rescue Exception => error
      test.flunk("Expected no exception, but #{error.class}: #{error.message}")
    end
  end

  class OutputMatcher
    def initialize(pattern = nil)
      @pattern = pattern
      @stream = :stdout
    end

    def to_stdout
      @stream = :stdout
      self
    end

    def to_stderr
      @stream = :stderr
      self
    end

    def assert_match(test, actual)
      output = capture_output(test, actual)
      return test.refute_empty(output) if @pattern.nil?

      assert_pattern(test, output)
    end

    def refute_match(test, actual)
      output = capture_output(test, actual)
      return test.assert_empty(output) if @pattern.nil?

      refute_pattern(test, output)
    end

    private

    def capture_output(test, actual)
      test.assert_respond_to(actual, :call)

      stdout, stderr = test.send(:capture_io) { actual.call }
      @stream == :stdout ? stdout : stderr
    end

    def assert_pattern(test, output)
      if @pattern.is_a?(Regexp)
        test.assert_match(@pattern, output)
      else
        test.assert_equal(@pattern.to_s, output)
      end
    end

    def refute_pattern(test, output)
      if @pattern.is_a?(Regexp)
        test.refute_match(@pattern, output)
      else
        test.refute_equal(@pattern.to_s, output)
      end
    end
  end

  class HaveBeenMadeMatcher
    def initialize
      @times = nil
    end

    def times(count)
      @times = count
      self
    end

    def assert_match(test, actual)
      executed = WebMock::RequestRegistry.instance.times_executed(actual)
      return test.assert_operator(executed, :>, 0, "Expected request to be made at least once") if @times.nil?

      test.assert_equal(@times, executed)
    end

    def refute_match(test, actual)
      executed = WebMock::RequestRegistry.instance.times_executed(actual)
      return test.assert_equal(0, executed) if @times.nil?

      test.refute_equal(@times, executed)
    end
  end

  class BeUtcMatcher
    def assert_match(test, actual)
      test.assert_respond_to(actual, :utc?)
      test.assert_predicate(actual, :utc?, "Expected #{actual.inspect} to be UTC")
    end

    def refute_match(test, actual)
      test.assert_respond_to(actual, :utc?)
      test.refute_predicate(actual, :utc?, "Expected #{actual.inspect} not to be UTC")
    end
  end

  class BeMissingMatcher
    def assert_match(test, actual)
      test.assert_respond_to(actual, :missing?)
      test.assert_predicate(actual, :missing?, "Expected #{actual.inspect} to be missing")
    end

    def refute_match(test, actual)
      test.assert_respond_to(actual, :missing?)
      test.refute_predicate(actual, :missing?, "Expected #{actual.inspect} not to be missing")
    end
  end

  class BeFalsyMatcher
    def assert_match(test, actual)
      test.refute(actual)
    end

    def refute_match(test, actual)
      test.assert(actual)
    end
  end

  module ArgumentMatching
    private

    def arguments_match?(actual_args, actual_kwargs)
      return true unless @has_with

      candidates = [[actual_args, actual_kwargs]]

      unless actual_kwargs.empty?
        candidates << [actual_args + [actual_kwargs], {}]
      end

      if @with_kwargs.any? && actual_kwargs.empty? && !actual_args.empty? && actual_args.last.is_a?(Hash)
        candidates << [actual_args[0...-1], actual_args.last]
      end

      candidates.any? do |candidate_args, candidate_kwargs|
        args_and_kwargs_match?(candidate_args, candidate_kwargs)
      end
    end

    def args_and_kwargs_match?(actual_args, actual_kwargs)
      return false unless @with_args.length == actual_args.length
      return false unless @with_kwargs.keys.sort == actual_kwargs.keys.sort

      positional_match = @with_args.zip(actual_args).all? do |expected, received|
        RSpecCompatibility.value_matches?(expected, received)
      end
      return false unless positional_match

      @with_kwargs.all? do |key, expected|
        RSpecCompatibility.value_matches?(expected, actual_kwargs[key])
      end
    end
  end

  class ReceiveRule
    include ArgumentMatching

    def initialize(patch:, matcher:, implementation:, expectation_block:, ordered_index: nil)
      @patch = patch
      @method_name = matcher.method_name
      @with_args = matcher.with_args
      @with_kwargs = matcher.with_kwargs
      @has_with = matcher.with?
      @implementation = implementation
      @expectation_block = expectation_block
      @ordered_index = ordered_index
      @return_values = matcher.return_values.dup
      @yield_args = matcher.yield_args
      @raise_error = matcher.raise_error
      @call_original = matcher.call_original?
      @calls = 0
    end

    def invoke(receiver, *args, **kwargs, &block)
      @patch.registry.assert_order!(@ordered_index) unless @ordered_index.nil?
      @calls += 1

      yielded_result = block.call(*@yield_args) if @yield_args && block

      raise @raise_error unless @raise_error.nil?

      return @expectation_block.call(*args, **kwargs, &block) unless @expectation_block.nil?
      return @implementation.call(*args, **kwargs, &block) unless @implementation.nil?
      return @patch.call_original(receiver, *args, **kwargs, &block) if @call_original
      return yielded_result if !@yield_args.nil? && @return_values.empty?

      next_return_value
    end

    def matches_call?(args, kwargs)
      arguments_match?(args, kwargs)
    end

    private

    def next_return_value
      return nil if @return_values.empty?
      return @return_values.first if @return_values.length == 1

      @return_values.shift
    end
  end

  class ExpectedReceiveRule < ReceiveRule
    def initialize(patch:, matcher:, times:, expectation_block:, ordered_index: nil)
      super(
        patch:,
        matcher:,
        implementation: nil,
        expectation_block:,
        ordered_index:,
      )
      @times = times
      @mock = Minitest::Mock.new
      @times.times do
        @mock.expect(:call, true) do |*args, **kwargs|
          matches_call?(args, kwargs)
        end
      end
    end

    def available_for?(args, kwargs)
      pending? && matches_call?(args, kwargs)
    end

    def invoke(receiver, *args, **kwargs, &block)
      @mock.call(*args, **kwargs)
      super
    rescue MockExpectationError, ArgumentError => error
      @patch.test.flunk(error.message)
    end

    def pending?
      @calls < @times
    end

    def verify!
      @patch.test.assert_mock(@mock)
    end
  end

  class AllowedReceiveRule < ReceiveRule
    def initialize(patch:, matcher:, expectation_block:)
      super(
        patch:,
        matcher:,
        implementation: nil,
        expectation_block:,
      )
    end

    def available_for?(args, kwargs)
      matches_call?(args, kwargs)
    end

    def verify!
      true
    end
  end

  class ForbiddenReceiveRule
    include ArgumentMatching

    def initialize(patch:, matcher:)
      @patch = patch
      @method_name = matcher.method_name
      @with_args = matcher.with_args
      @with_kwargs = matcher.with_kwargs
      @has_with = matcher.with?
    end

    def matches_call?(args, kwargs)
      arguments_match?(args, kwargs)
    end

    def invoke(args, kwargs)
      @patch.test.flunk("Expected #{@patch.target_description}.#{@method_name} not to be called, got #{args.inspect} #{kwargs.inspect}")
    end

    def verify!
      true
    end
  end

  class MethodPatch
    attr_reader :registry, :test

    def initialize(registry:, test:, target:, method_name:, any_instance:)
      @registry = registry
      @test = test
      @target = target
      @any_instance = any_instance
      @method_name = method_name.to_sym
      @expectations = []
      @allowances = []
      @forbidden = []
      install_patch
    end

    def target_description
      if @any_instance
        "#{@target}#any_instance"
      else
        @target.inspect
      end
    end

    def add_expected_receive(matcher, expectation_block)
      ordered_index = matcher.ordered? ? registry.next_order_index : nil
      times = matcher.times || 1
      @expectations << ExpectedReceiveRule.new(
        patch: self,
        matcher:,
        times:,
        expectation_block:,
        ordered_index:,
      )
    end

    def add_allowed_receive(matcher, expectation_block)
      @allowances << AllowedReceiveRule.new(
        patch: self,
        matcher:,
        expectation_block:,
      )
    end

    def add_forbidden_receive(matcher)
      @forbidden << ForbiddenReceiveRule.new(patch: self, matcher:)
    end

    def dispatch(receiver, *args, **kwargs, &block)
      forbidden_rule = @forbidden.find { |rule| rule.matches_call?(args, kwargs) }
      return forbidden_rule.invoke(args, kwargs) unless forbidden_rule.nil?

      expectation = @expectations.find { |rule| rule.available_for?(args, kwargs) }
      unless expectation.nil?
        return expectation.invoke(receiver, *args, **kwargs, &block)
      end

      allowance = @allowances.find { |rule| rule.available_for?(args, kwargs) }
      unless allowance.nil?
        return allowance.invoke(receiver, *args, **kwargs, &block)
      end

      test.flunk("Unexpected call to #{target_description}.#{@method_name} with #{args.inspect} #{kwargs.inspect}")
    end

    def verify!
      @expectations.each(&:verify!)
      @allowances.each(&:verify!)
      @forbidden.each(&:verify!)
    end

    def restore!
      return if @restored

      owner = @owner
      method_name = @method_name
      aliased_name = @aliased_name
      had_original = @had_original

      owner.class_eval do
        if had_original
          alias_method(method_name, aliased_name)
          remove_method(aliased_name)
        else
          remove_method(method_name)
        end
      end

      @restored = true
    end

    def call_original(receiver, *args, **kwargs, &block)
      return nil unless @had_original

      receiver.__send__(@aliased_name, *args, **kwargs, &block)
    end

    private

    def install_patch
      @owner = @any_instance ? @target : @target.singleton_class
      @visibility = visibility_for(@owner, @method_name)
      @had_original = method_defined?(@owner, @method_name)
      @aliased_name = :"__rspec_compat_original_#{object_id}_#{@method_name}"

      owner = @owner
      method_name = @method_name
      aliased_name = @aliased_name
      visibility = @visibility
      had_original = @had_original
      patch = self

      owner.class_eval do
        alias_method(aliased_name, method_name) if had_original

        define_method(method_name) do |*args, **kwargs, &block|
          patch.dispatch(self, *args, **kwargs, &block)
        end

        send(visibility, method_name) unless visibility == :public
      end
    end

    def method_defined?(owner, method_name)
      owner.method_defined?(method_name) ||
        owner.private_method_defined?(method_name) ||
        owner.protected_method_defined?(method_name)
    end

    def visibility_for(owner, method_name)
      return :private if owner.private_method_defined?(method_name)
      return :protected if owner.protected_method_defined?(method_name)

      :public
    end
  end

  class MockRegistry
    def initialize(test)
      @test = test
      @method_patches = {}
      @constant_stubs = []
      @next_order_index = 1
      @consumed_order_index = 1
    end

    def register_receive(target:, matcher:, allow:, negative:, any_instance:, expectation_block:)
      patch = fetch_patch(target:, method_name: matcher.method_name, any_instance:)

      if negative
        patch.add_forbidden_receive(matcher)
      elsif allow
        patch.add_allowed_receive(matcher, expectation_block)
      else
        patch.add_expected_receive(matcher, expectation_block)
      end
    end

    def stub_constant(path, value)
      names = path.split("::").reject(&:empty?)
      parent = Object
      names[0..-2].each do |name|
        parent = parent.const_get(name)
      end

      constant_name = names.last
      existed = parent.const_defined?(constant_name, false)
      previous_value = existed ? parent.const_get(constant_name, false) : nil

      parent.send(:remove_const, constant_name) if existed
      parent.const_set(constant_name, value)

      @constant_stubs << [parent, constant_name, existed, previous_value]
      value
    end

    def verify!
      @method_patches.each_value(&:verify!)
    end

    def cleanup!
      @method_patches.each_value(&:restore!)
      restore_constants
    end

    def next_order_index
      current = @next_order_index
      @next_order_index += 1
      current
    end

    def assert_order!(expected_index)
      if expected_index != @consumed_order_index
        @test.flunk("Expected ordered call ##{expected_index}, but got ##{@consumed_order_index}")
      end

      @consumed_order_index += 1
    end

    private

    def fetch_patch(target:, method_name:, any_instance:)
      key = [target.object_id, any_instance, method_name.to_sym]
      @method_patches[key] ||= MethodPatch.new(
        registry: self,
        test: @test,
        target:,
        method_name:,
        any_instance:,
      )
    end

    def restore_constants
      @constant_stubs.reverse_each do |parent, constant_name, existed, previous_value|
        parent.send(:remove_const, constant_name) if parent.const_defined?(constant_name, false)
        parent.const_set(constant_name, previous_value) if existed
      end
      @constant_stubs.clear
    end
  end

  class ReceiveMatcher
    attr_reader :method_name, :with_args, :with_kwargs, :return_values, :yield_args, :times, :raise_error

    def initialize(method_name)
      @method_name = method_name.to_sym
      @with_args = []
      @with_kwargs = {}
      @has_with = false
      @return_values = []
      @yield_args = nil
      @call_original = false
      @ordered = false
      @times = nil
      @raise_error = nil
    end

    def with(*args, **kwargs)
      @has_with = true
      @with_args = args
      @with_kwargs = kwargs
      self
    end

    def and_return(*values)
      @return_values = values
      self
    end

    def and_call_original
      @call_original = true
      self
    end

    def ordered
      @ordered = true
      self
    end

    def once
      @times = 1
      self
    end

    def twice
      @times = 2
      self
    end

    def and_yield(*values)
      @yield_args = values
      self
    end

    def and_raise(error)
      @raise_error = error
      self
    end

    def ordered?
      @ordered
    end

    def call_original?
      @call_original
    end

    def with?
      @has_with
    end

    def assert_match(_test, _actual)
      RSpecCompatibility.matcher_error("`receive` matcher can only be used with expect(...).to / allow(...).to")
    end

    def refute_match(_test, _actual)
      RSpecCompatibility.matcher_error("`receive` matcher can only be used with expect(...).not_to")
    end
  end

  class AllowProxy
    def initialize(test, target, any_instance: false)
      @test = test
      @target = target
      @any_instance = any_instance
    end

    def to(matcher, &block)
      validate_receive_matcher!(matcher)
      @test.__rspec_registry.register_receive(
        target: @target,
        matcher:,
        allow: true,
        negative: false,
        any_instance: @any_instance,
        expectation_block: block,
      )
      matcher
    end

    private

    def validate_receive_matcher!(matcher)
      return if matcher.is_a?(ReceiveMatcher)

      RSpecCompatibility.matcher_error("allow(...).to only supports `receive(...)`")
    end
  end

  class AnyInstanceExpectationProxy
    def initialize(test, klass)
      @test = test
      @klass = klass
    end

    def to(matcher, &block)
      validate_receive_matcher!(matcher)
      @test.__rspec_registry.register_receive(
        target: @klass,
        matcher:,
        allow: false,
        negative: false,
        any_instance: true,
        expectation_block: block,
      )
      matcher
    end

    def not_to(matcher, &block)
      validate_receive_matcher!(matcher)
      @test.__rspec_registry.register_receive(
        target: @klass,
        matcher:,
        allow: false,
        negative: true,
        any_instance: true,
        expectation_block: block,
      )
      matcher
    end

    private

    def validate_receive_matcher!(matcher)
      return if matcher.is_a?(ReceiveMatcher)

      RSpecCompatibility.matcher_error("expect_any_instance_of(...).to only supports `receive(...)`")
    end
  end

  module InstanceMethods
    def __rspec_registry
      @__rspec_registry ||= MockRegistry.new(self)
    end

    def described_class
      klass = self.class

      while klass.respond_to?(:desc)
        description = klass.desc
        return description if description.is_a?(Module)

        klass = klass.superclass
      end

      nil
    end

    def subject
      super
    rescue NameError
      @_memoized ||= {}
      @_memoized.fetch("__default_subject__") do |key|
        @_memoized[key] = described_class&.new
      end
    end

    def allow(target)
      AllowProxy.new(self, target)
    end

    def allow_any_instance_of(klass)
      AllowProxy.new(self, klass, any_instance: true)
    end

    def expect_any_instance_of(klass)
      AnyInstanceExpectationProxy.new(self, klass)
    end

    def stub_const(path, value)
      __rspec_registry.stub_constant(path, value)
    end

    def double(_name = nil, stubs = nil, **kwargs)
      build_double(stubs, **kwargs)
    end

    def instance_double(_klass = nil, stubs = nil, **kwargs)
      build_double(stubs, **kwargs)
    end

    def class_double(_klass = nil, stubs = nil, **kwargs)
      build_double(stubs, **kwargs)
    end

    def anything
      return super if defined?(super)

      AnythingArgMatcher.new
    end

    def hash_including(hash = nil, **kwargs)
      matcher_hash = kwargs.empty? ? hash : kwargs
      HashIncludingArgMatcher.new(matcher_hash)
    end

    def kind_of(klass)
      KindOfArgMatcher.new(klass)
    end

    def instance_of(klass)
      InstanceOfArgMatcher.new(klass)
    end

    def receive(method_name)
      ReceiveMatcher.new(method_name)
    end

    def eq(expected)
      EqMatcher.new(expected)
    end

    def eql(expected)
      EqlMatcher.new(expected)
    end

    def equal(expected)
      EqualMatcher.new(expected)
    end

    def be(expected = UNSET)
      BeMatcher.new(expected)
    end

    def be_a(klass)
      BeKindOfMatcher.new(klass)
    end

    def be_an(klass)
      BeKindOfMatcher.new(klass)
    end

    def be_instance_of(klass)
      BeInstanceOfMatcher.new(klass)
    end

    def be_nil
      BeNilMatcher.new
    end

    def be_empty
      BeEmptyMatcher.new
    end

    def have_key(key)
      HaveKeyMatcher.new(key)
    end

    def include(*items)
      IncludeMatcher.new(items)
    end

    def match(pattern)
      MatchMatcher.new(pattern)
    end

    def respond_to(method_name)
      RespondToMatcher.new(method_name)
    end

    def all(matcher)
      AllMatcher.new(matcher)
    end

    def raise_error(error_class = Exception)
      RaiseErrorMatcher.new(error_class)
    end

    def output(pattern = nil)
      OutputMatcher.new(pattern)
    end

    def have_been_made
      HaveBeenMadeMatcher.new
    end

    def be_utc
      BeUtcMatcher.new
    end

    def be_missing
      BeMissingMatcher.new
    end

    def be_falsy
      BeFalsyMatcher.new
    end

    private

    def build_double(stubs = nil, **kwargs)
      methods = case stubs
                when nil
                  {}
                when Hash
                  stubs
                else
                  RSpecCompatibility.matcher_error("double stubs must be passed as a hash")
                end

      methods = methods.merge(kwargs)
      object = Object.new

      methods.each do |name, value|
        object.define_singleton_method(name) do |*args, **named_args, &block|
          if value.respond_to?(:call)
            value.call(*args, **named_args, &block)
          else
            value
          end
        end
      end

      object
    end
  end

  module Lifecycle
    def before_setup
      super
      @__rspec_registry = MockRegistry.new(self)
    end

    def after_teardown
      @__rspec_registry&.verify!
    ensure
      @__rspec_registry&.cleanup!
      super
    end
  end

end

unless defined?(RSpecCompatibility::INSTALLED)
  Minitest::Test.prepend(RSpecCompatibility::Lifecycle)
  Minitest::Test.include(RSpecCompatibility::InstanceMethods)

  Minitest::Expectation.class_eval do
    def to(matcher = nil, &block)
      if matcher.is_a?(::RSpecCompatibility::ReceiveMatcher)
        ctx.__rspec_registry.register_receive(
          target:,
          matcher:,
          allow: false,
          negative: false,
          any_instance: false,
          expectation_block: block,
        )
        return matcher
      end

      ::RSpecCompatibility.apply_matcher(ctx, target, matcher, negate: false)
    end

    def not_to(matcher = nil, &block)
      if matcher.is_a?(::RSpecCompatibility::ReceiveMatcher)
        ctx.__rspec_registry.register_receive(
          target:,
          matcher:,
          allow: false,
          negative: true,
          any_instance: false,
          expectation_block: block,
        )
        return matcher
      end

      ::RSpecCompatibility.apply_matcher(ctx, target, matcher, negate: true)
    end
  end

  Minitest::Spec::DSL.module_eval do
    unless method_defined?(:__rspec_compat_let)
      alias __rspec_compat_let let
    end

    def let(name, &block)
      name = name.to_s

      define_method(name) do
        @_memoized ||= {}
        @_memoized.fetch(name) { |key| @_memoized[key] = instance_eval(&block) }
      end
    end

    unless method_defined?(:__rspec_compat_subject)
      alias __rspec_compat_subject subject
    end

    def subject(name = nil, &block)
      return let(name, &block) unless name.nil?

      __rspec_compat_subject(&block)
    end

    alias context describe unless method_defined?(:context)
  end

  Kernel.module_eval do
    unless private_method_defined?(:__rspec_compat_describe)
      alias __rspec_compat_describe describe
    end

    def describe(desc, *additional_desc, &block)
      klass = __rspec_compat_describe(desc, *additional_desc, &block)
      ::RSpecCompatibility.autocover(klass, desc, *additional_desc)
      klass
    end
    private :describe

    def context(desc, *additional_desc, &block)
      describe(desc, *additional_desc, &block)
    end
    private :context

    def shared_examples_for(name, &block)
      ::RSpecCompatibility.shared_examples[name] = block
    end
    private :shared_examples_for

    def it_behaves_like(name)
      shared = ::RSpecCompatibility.shared_examples.fetch(name)
      class_exec(&shared)
    end
    private :it_behaves_like
  end

  RSpecCompatibility::INSTALLED = true
end
