# encoding: utf-8
require File.expand_path('../lib/twitter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'faraday', '~> 0.8'
  gem.add_dependency 'multi_json', '~> 1.3'
  gem.add_dependency 'simple_oauth', '~> 0.1.6'
  gem.add_development_dependency 'json'
  gem.add_development_dependency 'maruku'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'yard'
  gem.authors = ["John Nunemaker", "Wynn Netherland", "Erik Michaels-Ober", "Steve Richert"]
  gem.description = %q{A Ruby wrapper for the Twitter API.}
  gem.email = ['nunemaker@gmail.com', 'wynn.netherland@gmail.com', 'sferik@gmail.com', 'steve.richert@gmail.com']
  gem.files = %w(CHANGELOG.md LICENSE.md README.md Rakefile twitter.gemspec)
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.homepage = 'https://github.com/jnunemaker/twitter'
  gem.name = 'twitter'
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{Twitter API wrapper}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.test_files = Dir.glob("spec/**/*")
  gem.version = Twitter::Version
end
