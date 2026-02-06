require "minitest"
require "mutant/minitest/coverage"
require "rspec/core"

RSpec::Core::Runner.disable_autorun!

module RSpecWrapper
  module_function

  def run(spec_files)
    spec_files = Array(spec_files)

    # Ensure we don't leak example groups between runs.
    RSpec.world.reset
    result = RSpec::Core::Runner.run(spec_files, $stderr, $stdout)
    RSpec.world.reset

    result
  end
end
