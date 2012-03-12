# encoding: utf-8
require File.expand_path('../lib/twitter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'activesupport', ['>= 2.3.9', '< 4']
  gem.add_dependency 'faraday', '~> 0.7'
  gem.add_dependency 'multi_json', '~> 1.0'
  gem.add_dependency 'simple_oauth', '~> 0.1'
  gem.add_development_dependency 'json'
  gem.add_development_dependency 'maruku'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'yard'
  gem.authors = ["John Nunemaker", "Wynn Netherland", "Erik Michaels-Ober", "Steve Richert"]
  gem.description = %q{A Ruby wrapper for the Twitter API.}
  gem.email = ['nunemaker@gmail.com', 'wynn.netherland@gmail.com', 'sferik@gmail.com', 'steve.richert@gmail.com']
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/jnunemaker/twitter'
  gem.name = 'twitter'
  gem.post_install_message =<<eos
********************************************************************************

  You should follow @gem on Twitter for announcements and updates about the gem.
  https://twitter.com/gem

  Please direct any questions about the library to the mailing list.
  https://groups.google.com/group/ruby-twitter-gem

  Does your project or organization use this gem? Add it to the apps wiki!
  https://github.com/jnunemaker/twitter/wiki/apps

********************************************************************************
eos
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{Twitter API wrapper}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Twitter::Version.to_s
end
