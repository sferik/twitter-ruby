# -*- encoding: utf-8 -*-
require File.expand_path("../lib/twitter/version", __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency("bluecloth", "~> 2.0")
  s.add_development_dependency("fakeweb", "~> 1.3")
  s.add_development_dependency("json_pure", "~> 1.4")
  s.add_development_dependency("mocha", "~> 0.9")
  s.add_development_dependency("rake", "~> 0.8")
  s.add_development_dependency("shoulda", "~> 2.11")
  s.add_development_dependency("test-unit", "~> 2.1")
  s.add_development_dependency("yard", "~> 0.6")
  s.add_development_dependency("ZenTest", "~> 4.4")
  s.add_runtime_dependency("addressable", "~> 2.2.2")
  s.add_runtime_dependency("hashie", "~> 0.4.0")
  s.add_runtime_dependency("faraday", "~> 0.5.1")
  s.add_runtime_dependency("faraday_middleware", "~> 0.1.7")
  s.add_runtime_dependency("multi_json", "~> 0.0.4")
  s.add_runtime_dependency("multi_xml", "~> 0.1.1")
  s.add_runtime_dependency("simple_oauth", "~> 0.1.1")
  s.authors = ["John Nunemaker", "Wynn Netherland", "Erik Michaels-Ober"]
  s.description = %q{A Ruby wrapper for the Twitter REST and Search APIs.}
  s.email = ["nunemaker@gmail.com"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://rubygems.org/gems/twitter"
  s.name = "twitter"
  s.platform = Gem::Platform::RUBY
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = "twitter"
  s.summary = %q{Ruby wrapper for the Twitter API}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Twitter::VERSION
end
